#!/usr/bin/env node
import fs from 'fs';
import path from 'path';

console.log('🔍 Verifying deployment configuration...\n');

const checks = [
  {
    name: 'package.json build script',
    check: () => {
      const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
      return pkg.scripts && pkg.scripts.build === 'vite build';
    }
  },
  {
    name: 'vite.config.ts with base: "./"',
    check: () => {
      const config = fs.readFileSync('vite.config.ts', 'utf8');
      return config.includes('base: \'./\'') || config.includes('base: "./"');
    }
  },
  {
    name: 'dist/ folder exists',
    check: () => fs.existsSync('dist')
  },
  {
    name: 'index.html in dist/',
    check: () => fs.existsSync('dist/index.html')
  },
  {
    name: '_redirects file for SPA routing',
    check: () => fs.existsSync('dist/_redirects') || fs.existsSync('public/_redirects')
  },
  {
    name: 'netlify.toml configuration',
    check: () => {
      if (!fs.existsSync('netlify.toml')) return false;
      const config = fs.readFileSync('netlify.toml', 'utf8');
      return config.includes('command = "npm run build"') && config.includes('publish = "dist"');
    }
  },
  {
    name: 'Tailwind CSS configured',
    check: () => fs.existsSync('tailwind.config.ts')
  },
  {
    name: 'Assets properly linked',
    check: () => {
      if (!fs.existsSync('dist/index.html')) return false;
      const html = fs.readFileSync('dist/index.html', 'utf8');
      return html.includes('./assets/') && html.includes('.css') && html.includes('.js');
    }
  }
];

let allPassed = true;

checks.forEach(({ name, check }) => {
  const passed = check();
  console.log(`${passed ? '✅' : '❌'} ${name}`);
  if (!passed) allPassed = false;
});

console.log('\n📊 Build Statistics:');
if (fs.existsSync('dist')) {
  const files = fs.readdirSync('dist');
  console.log(`   Files in dist/: ${files.length}`);
  
  if (fs.existsSync('dist/assets')) {
    const assets = fs.readdirSync('dist/assets');
    console.log(`   Asset files: ${assets.length}`);
  }
  
  if (fs.existsSync('dist/index.html')) {
    const size = fs.statSync('dist/index.html').size;
    console.log(`   index.html size: ${size} bytes`);
  }
}

console.log('\n🚀 Deployment Instructions:');
console.log('1. Run: npm install');
console.log('2. Run: npm run build');
console.log('3. Upload dist/ folder contents to your hosting service');
console.log('4. Or use: git push (for connected repositories)');

console.log('\n🌐 Live URLs:');
console.log('- Netlify: https://ecosphere-ai.netlify.app');
console.log('- Preview: npm run preview (for local testing)');

if (allPassed) {
  console.log('\n🎉 All deployment checks passed! Ready for production.');
  process.exit(0);
} else {
  console.log('\n⚠️  Some checks failed. Please review the configuration.');
  process.exit(1);
}
