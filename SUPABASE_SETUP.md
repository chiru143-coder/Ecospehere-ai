# Supabase Integration Setup Guide

## 🚀 Quick Setup

### 1. Create a Supabase Project

1. Go to [Supabase](https://supabase.com) and create a new project
2. Wait for the project to be fully initialized
3. Go to Project Settings → API
4. Copy your Project URL and anon key

### 2. Configure Environment Variables

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Update `.env` with your Supabase credentials:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
VITE_GOOGLE_MAPS_API_KEY=your-google-maps-api-key
```

### 3. Create Database Schema

1. Go to your Supabase project → SQL Editor
2. Copy the contents of `supabase-schema.sql`
3. Run the SQL to create all tables, policies, and functions

### 4. Enable Realtime (Optional)

1. Go to Database → Publications
2. Enable realtime for the following tables:
   - `sensor_data`
   - `alerts`
   - `manual_reports`

## 🔧 Features Enabled

### ✅ Real-time Data Streaming
- Live sensor data updates across all domains
- Real-time alerts and notifications
- Automatic data synchronization

### ✅ User Authentication
- Supabase Auth integration
- User profiles and preferences
- Row-level security (RLS)

### ✅ Data Storage
- Environmental sensor data
- Manual reports and alerts
- User preferences and settings
- File uploads for images

### ✅ Advanced Features
- Real-time subscriptions
- Automatic data validation
- Secure API endpoints
- Database triggers and functions

## 📊 Database Structure

### Tables Created:
- **users**: User profiles and preferences
- **alerts**: Environmental alerts and notifications
- **sensor_data**: Real-time environmental monitoring data
- **manual_reports**: User-submitted reports
- **predictions**: AI model predictions and forecasts

### Security:
- Row Level Security (RLS) enabled
- User-based access control
- Admin-only functions for sensitive operations

## 🧪 Testing Real-time Features

### 1. Add Test Data
Run this in your Supabase SQL Editor to add sample sensor data:
```sql
SELECT simulate_sensor_data();
```

### 2. Test Real-time Updates
1. Open the Air Quality Dashboard
2. Run the simulation function again
3. Watch for real-time updates in the UI

### 3. Test Authentication
1. Go to `/signup` and create a test account
2. Verify email (check Supabase Auth logs)
3. Login and test profile updates

## 🔄 Real-time Features in Action

### Air Quality Domain
- Live AQI updates from database
- Real-time pollution alerts
- Automatic chart updates

### Water Quality Domain
- Contamination detection alerts
- Live water quality measurements
- Automatic map updates

### Soil Health Domain
- Nutrient level monitoring
- Degradation alerts
- Real-time crop recommendations

### Forest Fire Domain
- Fire risk alerts
- Emergency report notifications
- Live prediction updates

## 🛠️ Development Features

### Data Simulation
The schema includes a `simulate_sensor_data()` function that generates realistic test data for all domains.

### Automatic Updates
Triggers automatically update `updated_at` timestamps when records are modified.

### File Storage
Configured storage bucket for uploading images and documents.

## 🚨 Troubleshooting

### Connection Issues
1. Verify your Supabase URL and API key
2. Check browser console for errors
3. Ensure RLS policies are correctly configured

### Real-time Not Working
1. Enable realtime in Supabase dashboard
2. Check subscription status in browser dev tools
3. Verify table publications are enabled

### Authentication Issues
1. Check email confirmation settings
2. Verify RLS policies for user table
3. Test with email providers that support development

## 📈 Monitoring

### Supabase Dashboard
- Monitor API usage
- View real-time connections
- Check database performance

### Application Logs
- Check browser console for WebSocket connections
- Monitor network requests in dev tools
- Verify data updates in real-time

## 🔐 Security Best Practices

1. **Never commit real API keys** to version control
2. **Use environment variables** for all sensitive data
3. **Enable RLS** on all tables with user data
4. **Validate data** before database insertion
5. **Monitor usage** to prevent abuse

## 🚀 Production Deployment

1. Set up proper environment variables
2. Configure custom domain (optional)
3. Enable database backups
4. Set up monitoring and alerts
5. Configure edge functions if needed

Your ECOSPHERE AI application now has full Supabase integration with real-time capabilities! 🌍✨
