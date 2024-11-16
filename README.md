## **AenzbiStudio IDE Setup and Deployment**

### **Features**
- Cross-platform support: Android, Windows, iOS, and Cloud.
- Integrated CLI with powerful subcommands (build, deploy, lint).
- Real-time collaboration tools.
- Integration with fiscal printers (ESC/POS).
- Codespace prebuild support.
- Deployment to African regions on Firebase and Google Cloud.

---

### **Requirements**
#### **General Prerequisites**
1. Install the following tools:
   - **Git**: [Download](https://git-scm.com/)
   - **Docker**: [Download](https://www.docker.com/)
   - **Node.js**: [Download](https://nodejs.org/)
   - **Flutter**: [Installation Guide](https://flutter.dev/docs/get-started/install)
   - **Android Studio**: [Download](https://developer.android.com/studio)
   - **Xcode** (macOS): Available on the Mac App Store.
   - **Google Cloud CLI**: [Download](https://cloud.google.com/sdk/docs/install)
   - **Firebase CLI**: Install via npm:
     ```bash
     npm install -g firebase-tools
     ```
2. Set up a **GitHub Codespaces**-enabled repository.

---

### **Directory Structure**
```
AenzbiStudio/
├── .devcontainer/
│   └── devcontainer.json
├── android/
├── ios/
├── web/
├── backend/
├── cli/
├── scripts/
└── README.md
```

---

### **1. Codespaces Configuration**
Create the `.devcontainer/devcontainer.json` file:
```json
{
  "name": "AenzbiStudio",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "20"
    },
    "ghcr.io/devcontainers/features/docker-outside-docker:1": {}
  },
  "postCreateCommand": "bash scripts/setup.sh",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-vscode.vscode-node-azure-pack",
        "ms-azuretools.vscode-docker",
        "dbaeumer.vscode-eslint"
      ]
    }
  }
}
```

---

### **2. Bash Script for Setup and Deployment**
Save the following Bash script as `scripts/setup.sh`:

```bash
#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up AenzbiStudio IDE...${NC}"

# 1. Install Dependencies
echo -e "${GREEN}Installing dependencies...${NC}"
sudo apt-get update -y
sudo apt-get install -y curl git build-essential

# 2. Install Node.js
if ! command -v node &> /dev/null; then
  echo -e "${GREEN}Installing Node.js...${NC}"
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

# 3. Install Flutter
if ! command -v flutter &> /dev/null; then
  echo -e "${GREEN}Installing Flutter...${NC}"
  git clone https://github.com/flutter/flutter.git ~/flutter
  export PATH="$PATH:~/flutter/bin"
fi

# 4. Install Firebase CLI
if ! command -v firebase &> /dev/null; then
  echo -e "${GREEN}Installing Firebase CLI...${NC}"
  npm install -g firebase-tools
fi

# 5. Initialize Firebase Project
echo -e "${GREEN}Initializing Firebase project...${NC}"
firebase login
firebase init hosting

# 6. Build Flutter Apps
echo -e "${GREEN}Building Flutter apps...${NC}"
flutter pub get
flutter build apk --release
flutter build ios --release

# 7. Setup Backend
echo -e "${GREEN}Setting up backend...${NC}"
cd backend
npm install
cd ..

# 8. Deploy Cloud Functions
echo -e "${GREEN}Deploying Cloud Functions...${NC}"
firebase deploy --only functions

# 9. Google Cloud Setup
echo -e "${GREEN}Configuring Google Cloud...${NC}"
gcloud auth login
gcloud config set project aenzbi-idle
gcloud app deploy

# 10. Setup Codespaces Prebuild
echo -e "${GREEN}Configuring Codespaces prebuild...${NC}"
git add .devcontainer
git commit -m "Add Codespaces prebuild configuration"
git push

echo -e "${GREEN}Setup complete!${NC}"
```

---

### **3. Fiscal Printer Integration**
In the `backend/` directory, create a file `fiscalPrinter.js`:
```javascript
const escpos = require('escpos');
escpos.USB = require('escpos-usb');
const device = new escpos.USB();

const printReceipt = (data) => {
  const printer = new escpos.Printer(device);
  device.open(() => {
    printer
      .text(data)
      .cut()
      .close();
  });
};

module.exports = printReceipt;
```

---

### **4. Real-Time Collaboration**
Add WebSocket support to the backend:
```javascript
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

io.on('connection', (socket) => {
  console.log('User connected');
  socket.on('code-edit', (data) => {
    socket.broadcast.emit('code-edit', data);
  });
});

server.listen(3000, () => {
  console.log('Server running on port 3000');
});
```

---

### **5. African Region Deployment**
#### Firebase:
Edit `firebase.json`:
```json
{
  "hosting": {
    "region": "africa-south1"
  }
}
```

#### Google Cloud:
Deploy with:
```bash
gcloud functions deploy aenzbistudio \
  --region=africa-south1 \
  --runtime=nodejs20 \
  --trigger-http
```

---

### **Usage**
1. Run the setup script:
   ```bash
   bash scripts/setup.sh
   ```
2. Open the Flutter project for Android/iOS:
   ```bash
   flutter run
   ```
3. Start the backend:
   ```bash
   node backend/server.js
   ```
4. Deploy to Firebase:
   ```bash
   firebase deploy
   ```

---

This script and documentation will help you configure, build, and deploy **AenzbiStudio** across all platforms, ensuring comprehensive functionality and scalability.
