#!/bin/bash

# Base directory for all projects
BASE_DIR="$HOME/TrendingProjects"
mkdir -p "$BASE_DIR"

# Function to initialize a Git repository
initialize_git() {
  git init
  echo "# $1 Project" > README.md
  git add README.md
  git commit -m "Initial commit for $1 Project"
}

# Function to create Node.js project with Express
create_node_project() {
  npm init -y
  npm install express
}

# Function to create a Python project with a virtual environment
create_python_project() {
  python3 -m venv venv
  source venv/bin/activate
  pip install --upgrade pip
  deactivate
}

# Function to create a Flutter project
create_flutter_project() {
  flutter create .
}

# Function to initialize a Django project
initialize_django() {
  source venv/bin/activate
  pip install django
  django-admin startproject mysite
  deactivate
}

# List of projects and descriptions
declare -A projects=(
  ["AI_and_ML"]="Machine Learning & AI Apps"
  ["Green_Tech"]="Green Tech Solutions"
  ["Ecommerce"]="E-commerce Innovations"
  ["Blockchain"]="Blockchain & DeFi Solutions"
  ["Remote_Work_Tools"]="Remote Work & Collaboration Tools"
  ["Health_Wellness"]="Health & Wellness Tech"
  ["Cybersecurity"]="Cybersecurity Solutions"
  ["EdTech"]="EdTech Solutions"
  ["Smart_Home_IoT"]="Smart Home & IoT Solutions"
  ["AR_VR"]="Augmented Reality & Virtual Reality"
)

# Loop through projects and set up directories
for key in "${!projects[@]}"; do
  project_name="${projects[$key]}"
  project_dir="$BASE_DIR/$project_name"
  echo "Setting up project: $project_name at $project_dir"
  mkdir -p "$project_dir"
  cd "$project_dir" || exit

  # Initialize Git
  initialize_git "$project_name"

  # Create environment and setup specific to each project type
  case $key in
    "AI_and_ML")
      mkdir src data models
      create_python_project
      echo "Installing basic AI/ML libraries"
      source venv/bin/activate
      pip install numpy pandas scikit-learn jupyter
      deactivate
      ;;
      
    "Green_Tech")
      mkdir src energy_monitoring waste_management
      create_node_project
      echo "Green Tech: Energy tracking APIs can be added here"
      ;;
    
    "Ecommerce")
      npx create-react-app ecommerce-app
      cd ecommerce-app || exit
      npm install redux react-router-dom
      ;;
    
    "Blockchain")
      create_node_project
      npm install web3 ethers
      echo "Blockchain: Wallet and smart contract configurations go here"
      ;;
    
    "Remote_Work_Tools")
      npx create-react-app remote-collaboration
      cd remote-collaboration || exit
      npm install socket.io-client react-router-dom
      echo "Remote Collaboration: Chat and video tools implemented here"
      ;;
    
    "Health_Wellness")
      create_flutter_project
      echo "Health & Wellness: Flutter health tracking app setup complete"
      ;;
    
    "Cybersecurity")
      mkdir src security
      create_python_project
      echo "Installing security libraries"
      source venv/bin/activate
      pip install requests cryptography
      deactivate
      echo "Cybersecurity: Security-focused code can be added here"
      ;;
    
    "EdTech")
      npx create-react-app edtech-app
      cd edtech-app || exit
      npm install react-router-dom
      echo "EdTech: Interactive learning modules to be built here"
      ;;
    
    "Smart_Home_IoT")
      mkdir -p src/iot devices sensors
      create_node_project
      echo "Installing IoT packages"
      npm install johnny-five mqtt
      echo "Smart Home IoT: Sensor and device logic implemented here"
      ;;
    
    "AR_VR")
      create_flutter_project
      echo "AR & VR: For advanced VR, consider Unity/Unreal"
      echo "Augmented Reality components added here"
      ;;
    
    *)
      echo "No specific setup for $project_name"
      ;;
  esac

  # Move back to base directory for next project
  cd "$BASE_DIR" || exit
done

echo "All projects have been initialized in $BASE_DIR."