-- ECOSPHERE AI Database Schema for Supabase
-- Run this in your Supabase SQL Editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  area TEXT,
  profile_picture TEXT,
  preferences JSONB DEFAULT '{
    "notifications": true,
    "soundAlerts": true,
    "language": "en",
    "theme": "dark"
  }'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Alerts table
CREATE TABLE public.alerts (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  area TEXT NOT NULL,
  message TEXT NOT NULL,
  severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  domain TEXT NOT NULL CHECK (domain IN ('air', 'water', 'soil', 'forest')),
  sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  resolved_at TIMESTAMP WITH TIME ZONE,
  user_id UUID REFERENCES public.users(id)
);

-- Sensor data table
CREATE TABLE public.sensor_data (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  sensor_id TEXT NOT NULL,
  domain TEXT NOT NULL CHECK (domain IN ('air', 'water', 'soil', 'forest')),
  location JSONB NOT NULL, -- {lat, lng, name}
  data JSONB NOT NULL,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  quality_score DECIMAL(3,2)
);

-- Manual reports table
CREATE TABLE public.manual_reports (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.users(id) NOT NULL,
  domain TEXT NOT NULL CHECK (domain IN ('air', 'water', 'soil', 'forest')),
  location JSONB NOT NULL, -- {lat, lng, description}
  description TEXT NOT NULL,
  severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  images TEXT[], -- Array of image URLs
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'investigating', 'resolved')),
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Predictions table
CREATE TABLE public.predictions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  domain TEXT NOT NULL CHECK (domain IN ('air', 'water', 'soil', 'forest')),
  model_type TEXT NOT NULL,
  prediction_data JSONB NOT NULL,
  confidence_score DECIMAL(5,2) NOT NULL,
  valid_from TIMESTAMP WITH TIME ZONE NOT NULL,
  valid_until TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for better performance
CREATE INDEX idx_sensor_data_domain ON sensor_data(domain);
CREATE INDEX idx_sensor_data_timestamp ON sensor_data(timestamp DESC);
CREATE INDEX idx_sensor_data_sensor_id ON sensor_data(sensor_id);
CREATE INDEX idx_alerts_domain ON alerts(domain);
CREATE INDEX idx_alerts_sent_at ON alerts(sent_at DESC);
CREATE INDEX idx_alerts_severity ON alerts(severity);
CREATE INDEX idx_manual_reports_domain ON manual_reports(domain);
CREATE INDEX idx_manual_reports_timestamp ON manual_reports(timestamp DESC);
CREATE INDEX idx_manual_reports_user_id ON manual_reports(user_id);
CREATE INDEX idx_predictions_domain ON predictions(domain);
CREATE INDEX idx_predictions_valid_from ON predictions(valid_from);

-- Row Level Security (RLS) Policies

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sensor_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.manual_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.predictions ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- Alerts policies (readable by all authenticated users)
CREATE POLICY "Alerts are viewable by authenticated users" ON public.alerts
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Admins can manage alerts" ON public.alerts
  FOR ALL TO authenticated 
  USING (
    EXISTS (
      SELECT 1 FROM public.users 
      WHERE id = auth.uid() 
      AND email = 'chirusai0302@gmail.com'
    )
  );

-- Sensor data policies (readable by all authenticated users)
CREATE POLICY "Sensor data is viewable by authenticated users" ON public.sensor_data
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Sensor data can be inserted by authenticated users" ON public.sensor_data
  FOR INSERT TO authenticated WITH CHECK (true);

-- Manual reports policies
CREATE POLICY "Users can view all reports" ON public.manual_reports
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Users can create own reports" ON public.manual_reports
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reports" ON public.manual_reports
  FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- Predictions policies (readable by all authenticated users)
CREATE POLICY "Predictions are viewable by authenticated users" ON public.predictions
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Predictions can be inserted by authenticated users" ON public.predictions
  FOR INSERT TO authenticated WITH CHECK (true);

-- Functions for automatic timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at columns
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_manual_reports_updated_at BEFORE UPDATE ON public.manual_reports
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Storage bucket for file uploads
INSERT INTO storage.buckets (id, name, public) VALUES ('ecosphere-files', 'ecosphere-files', true);

-- Storage policy for file uploads
CREATE POLICY "Users can upload files" ON storage.objects
  FOR INSERT TO authenticated WITH CHECK (bucket_id = 'ecosphere-files');

CREATE POLICY "Files are publicly accessible" ON storage.objects
  FOR SELECT USING (bucket_id = 'ecosphere-files');

-- Sample data for testing (optional)
INSERT INTO public.sensor_data (sensor_id, domain, location, data) VALUES
('AIR_001', 'air', '{"lat": 28.6139, "lng": 77.2090, "name": "Delhi Central"}', '{"pm25": 85, "pm10": 120, "no2": 45, "aqi": 156}'),
('WATER_001', 'water', '{"lat": 28.6139, "lng": 77.2090, "name": "Yamuna River"}', '{"ph": 7.2, "tds": 320, "turbidity": 3.1, "wqi": 78}'),
('SOIL_001', 'soil', '{"lat": 28.6139, "lng": 77.2090, "name": "Agricultural Zone A"}', '{"nitrogen": 42, "phosphorus": 28, "potassium": 135, "ph": 6.8}'),
('FOREST_001', 'forest', '{"lat": 28.6139, "lng": 77.2090, "name": "Forest Sector Alpha"}', '{"temperature": 32, "humidity": 45, "fire_risk_index": 75}');

-- Create a function for real-time sensor data simulation
CREATE OR REPLACE FUNCTION simulate_sensor_data()
RETURNS void AS $$
DECLARE
  domains text[] := ARRAY['air', 'water', 'soil', 'forest'];
  domain_name text;
BEGIN
  FOREACH domain_name IN ARRAY domains
  LOOP
    -- Insert simulated data for each domain
    CASE domain_name
      WHEN 'air' THEN
        INSERT INTO public.sensor_data (sensor_id, domain, location, data)
        VALUES (
          'AIR_SIM',
          'air',
          '{"lat": 28.6139, "lng": 77.2090, "name": "Live Sensor"}',
          json_build_object(
            'pm25', 20 + random() * 100,
            'pm10', 30 + random() * 150,
            'no2', 10 + random() * 80,
            'aqi', 50 + random() * 200
          )::jsonb
        );
      WHEN 'water' THEN
        INSERT INTO public.sensor_data (sensor_id, domain, location, data)
        VALUES (
          'WATER_SIM',
          'water',
          '{"lat": 28.6139, "lng": 77.2090, "name": "Live Sensor"}',
          json_build_object(
            'ph', 6 + random() * 2,
            'tds', 100 + random() * 400,
            'turbidity', 1 + random() * 10,
            'wqi', random() * 100
          )::jsonb
        );
      WHEN 'soil' THEN
        INSERT INTO public.sensor_data (sensor_id, domain, location, data)
        VALUES (
          'SOIL_SIM',
          'soil',
          '{"lat": 28.6139, "lng": 77.2090, "name": "Live Sensor"}',
          json_build_object(
            'nitrogen', 20 + random() * 60,
            'phosphorus', 10 + random() * 40,
            'potassium', 80 + random() * 200,
            'ph', 6 + random() * 2
          )::jsonb
        );
      WHEN 'forest' THEN
        INSERT INTO public.sensor_data (sensor_id, domain, location, data)
        VALUES (
          'FOREST_SIM',
          'forest',
          '{"lat": 28.6139, "lng": 77.2090, "name": "Live Sensor"}',
          json_build_object(
            'temperature', 25 + random() * 15,
            'humidity', 30 + random() * 40,
            'fire_risk_index', random() * 100,
            'wind_speed', 5 + random() * 20
          )::jsonb
        );
    END CASE;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
