# ECOSPHERE AI - Environmental Monitoring Platform

A comprehensive React-based Single Page Application (SPA) for environmental monitoring and analysis, built with modern web technologies and optimized for static deployment.

## 🌍 Features

- **Air Quality Monitoring** - Real-time air quality tracking with pollutant analysis
- **Water Quality Management** - AI-powered contamination detection and analysis
- **Soil Health Monitoring** - IoT sensor network integration and nutrient analysis
- **Forest Fire Detection** - GPS-based emergency reporting system
- **Weather Integration** - Location-based weather data and alerts
- **Multi-language Support** - English, Telugu, and Hindi
- **Mobile-Responsive Design** - Optimized for all device sizes
- **User Authentication** - Secure account management system

## 🛠️ Technology Stack

- **Frontend**: React 18 + TypeScript
- **Build Tool**: Vite 6.x
- **Styling**: Tailwind CSS with custom design system
- **UI Components**: Radix UI primitives
- **Animation**: Framer Motion
- **Charts**: Recharts
- **Routing**: React Router DOM
- **State Management**: React Context API
- **Icons**: Lucide React

## 🚀 Getting Started

### Prerequisites

- Node.js 18+ installed
- npm or yarn package manager

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd ecosphere-ai

# Install dependencies
npm install

# Start development server
npm run dev
```

### Development Scripts

```bash
npm run dev          # Start development server (localhost:8080)
npm run build        # Build for production (outputs to dist/)
npm run preview      # Preview production build locally
npm run typecheck    # Run TypeScript type checking
npm run format.fix   # Format code with Prettier
npm run test         # Run tests
npm run clean        # Clean dist/ folder
```

## 📦 Build & Deployment

### Building for Production

```bash
npm run build
```

This creates an optimized build in the `dist/` folder with:
- Minified and bundled JavaScript/CSS
- Optimized asset loading
- Proper cache headers
- Code splitting for better performance

### Deployment Options

#### 1. Netlify (Recommended)

The project is pre-configured for Netlify deployment:

1. **Automatic Deployment**: Push to GitHub and connect repository to Netlify
2. **Manual Deployment**: 
   - Run `npm run build`
   - Upload `dist/` folder contents to Netlify

**Configuration files included:**
- `netlify.toml` - Build settings and redirects
- `public/_redirects` - SPA routing support

#### 2. Vercel

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel --prod
```

#### 3. GitHub Pages / Static Hosting

After running `npm run build`, upload the `dist/` folder contents to any static hosting service.

## 🔧 Configuration Files

### `vite.config.ts`
- Optimized build configuration
- Code splitting for better performance
- Proper base path for static deployment
- Development server setup

### `netlify.toml`
- Build command: `npm run build`
- Publish directory: `dist`
- SPA routing redirects
- Security headers
- Asset caching

### `tailwind.config.ts`
- Custom design system
- Dark mode support
- Component-specific styling
- Responsive breakpoints

## 🏗️ Project Structure

```
ecosphere-ai/
├── client/                 # React application source
│   ├── components/        # Reusable UI components
│   ├── pages/            # Page components
│   ├── contexts/         # React Context providers
│   ├── hooks/            # Custom React hooks
│   └── lib/              # Utility functions
├── public/               # Static assets
│   ├── _redirects        # Netlify SPA routing
│   └── ...              # Images, favicon, etc.
├── dist/                 # Production build output
├── vite.config.ts        # Vite configuration
├── netlify.toml          # Netlify deployment config
├── tailwind.config.ts    # Tailwind CSS config
└── package.json          # Dependencies and scripts
```

## 🔐 Environment Variables

For production deployment, set these environment variables:

```bash
VITE_WEATHER_API_KEY=your_weather_api_key
VITE_MAPS_API_KEY=your_google_maps_key
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_key
```

## 🧪 Testing

```bash
npm run test        # Run unit tests
npm run typecheck   # TypeScript validation
```

## 🎨 Customization

### Theme Configuration
- Modify `tailwind.config.ts` for design system changes
- Update CSS variables in `client/global.css`
- Component styling in individual component files

### Adding New Pages
1. Create component in `client/pages/`
2. Add route in main router configuration
3. Update navigation components

## 🌐 Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 📱 Mobile Support

Fully responsive design optimized for:
- Mobile phones (320px+)
- Tablets (768px+)
- Desktop (1024px+)
- Large screens (1440px+)

## 🚨 Troubleshooting

### Common Issues

1. **Build Errors**: Run `npm run clean && npm install && npm run build`
2. **Routing Issues**: Ensure `_redirects` file is in `public/` folder
3. **Asset Loading**: Verify `base: './'` in `vite.config.ts`
4. **TypeScript Errors**: Run `npm run typecheck` for detailed errors

### Development Issues

- **Port Conflicts**: Change port in `vite.config.ts`
- **Module Resolution**: Check path aliases in `vite.config.ts`
- **Hot Reload**: Restart dev server if changes not reflecting

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check troubleshooting section above
- Review deployment logs for specific errors

---

**Built with ❤️ for environmental protection and monitoring** 🌍✨
