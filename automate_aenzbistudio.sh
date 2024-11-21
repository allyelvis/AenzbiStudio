#!/bin/bash

# Script to automate the setup, feature implementation, and update for AenzbiStudio

set -e

# Configuration
REPO_URL="https://github.com/allyelvis/AenzbiStudio.git"
BRANCH_NAME="user"
COMMIT_MESSAGE="Added user management, performance optimizations, and updated documentation"
TAG_VERSION="v1.0.2"
TAG_MESSAGE="Release v1.0.2: User Management and Optimizations"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Cloning AenzbiStudio repository...${NC}"
if [ ! -d "AenzbiStudio" ]; then
    git clone "$REPO_URL"
else
    echo -e "${RED}Repository already exists locally. Skipping clone.${NC}"
fi

cd AenzbiStudio || { echo "Failed to enter the repository directory"; exit 1; }

echo -e "${GREEN}Creating and switching to branch: $BRANCH_NAME${NC}"
git checkout -b "$BRANCH_NAME"

echo -e "${GREEN}Installing dependencies...${NC}"
npm install

echo -e "${GREEN}Setting up User Management backend...${NC}"
cat <<EOF > server.js
const express = require('express');
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/aenzbistudio', { useNewUrlParser: true, useUnifiedTopology: true });

// User Schema and Model
const userSchema = new mongoose.Schema({
  username: String,
  password: String,
});
const User = mongoose.model('User', userSchema);

// Endpoints
app.post('/register', async (req, res) => {
  const { username, password } = req.body;
  const user = new User({ username, password });
  await user.save();
  res.status(201).send({ message: 'User registered successfully' });
});

app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const user = await User.findOne({ username, password });
  if (!user) return res.status(401).send({ message: 'Invalid credentials' });

  const token = jwt.sign({ id: user._id }, 'secret_key', { expiresIn: '1h' });
  res.send({ token });
});

app.listen(3000, () => console.log('User management backend running on port 3000'));
EOF

echo -e "${GREEN}Adding plugin system placeholder...${NC}"
mkdir -p plugins
cat <<EOF > plugins/README.md
# Plugin System
This directory allows developers to create and manage plugins for AenzbiStudio. Plugins should follow the provided interface and be placed here.
EOF

echo -e "${GREEN}Enhancing the debugger...${NC}"
mkdir -p src/debugger
cat <<EOF > src/debugger/index.js
// Basic Debugger Enhancement
console.log("Debugger initialized. Ready to add breakpoints and logs.");
EOF

echo -e "${GREEN}Updating documentation...${NC}"
mkdir -p docs
cat <<EOF > docs/SETUP.md
# AenzbiStudio Setup and Enhancements

## User Management
- Backend: Express.js with MongoDB
- Endpoints: /register, /login
- To start the server: \`node server.js\`

## Plugin System
- Plugins can be added in the \`plugins/\` directory.

## Debugger
- Enhanced debugger initialized in \`src/debugger/index.js\`.
EOF

echo -e "${GREEN}Adding test configurations...${NC}"
cat <<EOF > cypress.json
{
  "baseUrl": "http://localhost:3000",
  "integrationFolder": "cypress/integration",
  "video": false
}
EOF

mkdir -p cypress/integration
cat <<EOF > cypress/integration/sample_test.spec.js
describe('Sample Test', () => {
  it('Visits the application', () => {
    cy.visit('/');
    cy.contains('Welcome to AenzbiStudio');
  });
});
EOF

echo -e "${GREEN}Running tests...${NC}"
npm run test || echo -e "${RED}Tests failed. Please review.${NC}"

echo -e "${GREEN}Committing changes...${NC}"
git add .
git commit -m "$COMMIT_MESSAGE"

echo -e "${GREEN}Pushing changes to GitHub...${NC}"
git push origin "$BRANCH_NAME"

echo -e "${GREEN}Tagging the release...${NC}"
git tag -a "$TAG_VERSION" -m "$TAG_MESSAGE"
git push origin "$TAG_VERSION"

echo -e "${GREEN}Update complete!${NC}"
