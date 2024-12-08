#!/bin/bash

# Prompt for the project name
read -p "Enter your project name: " PROJECT_NAME
while [[ -z "$PROJECT_NAME" ]]; do
    read -p "Enter your project name: " PROJECT_NAME
done

# Normalize project name to PEP 8 standards (snake_case)
PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Prompt for Python version
read -p "Enter the Python version to use (e.g., python3.8, python3.9) [default: latest available]: " PYTHON_VERSION

# Determine the default Python version if none is provided
if [[ -z "$PYTHON_VERSION" ]]; then
    PYTHON_VERSION=$(command -v python3 || echo "")
    if [[ -z "$PYTHON_VERSION" ]]; then
        echo "Error: No Python 3 installation found in PATH."
        exit 1
    fi
    echo "Using the latest available Python 3 version: $PYTHON_VERSION"
else
    # Validate the provided Python version
    if ! command -v "$PYTHON_VERSION" &> /dev/null; then
        echo "Error: $PYTHON_VERSION is not installed or not available in PATH."
        exit 1
    fi
    # Ensure the selected Python version is Python 3
    if ! "$PYTHON_VERSION" -c "import sys; sys.exit(0 if sys.version_info.major == 3 else 1)"; then
        echo "Error: Only Python 3 is supported. You selected: $PYTHON_VERSION"
        exit 1
    fi
fi

# Check compatibility with development tools
"$PYTHON_VERSION" -c "
import sys
major, minor = sys.version_info[:2]
if (major, minor) < (3, 8):
    print(f'Error: black, flake8, and pytest require Python 3.8 or newer. Current version: {sys.version}')
    sys.exit(1)
else:
    print(f'Python version {sys.version.split()[0]} is compatible with black, flake8, and pytest.')
" || exit 1

# Step 1: Create Project Directory
if ! mkdir "$PROJECT_NAME"; then
    echo "Error: Failed to create project directory."
    exit 1
fi
cd "$PROJECT_NAME" || exit

# Step 2: Create a Virtual Environment in .venv
"$PYTHON_VERSION" -m venv .venv
echo "Virtual environment (.venv) created with $PYTHON_VERSION."

# Step 3: Activate Virtual Environment
if source .venv/bin/activate; then
    echo "Virtual environment activated."
else
    echo "Warning: Could not activate the virtual environment automatically."
    echo "You may need to activate it manually using 'source .venv/bin/activate'."
fi

# Step 4: Initialize Git Repository
if ! git init; then
    echo "Warning: Git initialization failed. Ensure Git is installed."
fi

# Step 5: Create .gitignore File
cat > .gitignore <<EOL
.venv/
__pycache__/
*.pyc
*.pyo
EOL
echo ".gitignore file created."

# Step 6: Create pyproject.toml
cat > pyproject.toml <<EOL
[build-system]
requires = ["setuptools>=42", "wheel"]
build-backend = "setuptools.build_meta"
EOL
echo "pyproject.toml file created."

# Step 7: Create requirements.txt
touch requirements.txt

# Step 8: Install Development Tools
if ! pip install black flake8 pytest; then
    echo "Error: Failed to install development tools."
    exit 1
fi
echo "Development tools installed."

# Step 9: Generate requirements.txt
pip freeze > requirements.txt
echo "requirements.txt file generated with installed dependencies."

# Step 10: Create Source Directory
mkdir "$PROJECT_NAME"
touch "$PROJECT_NAME/__init__.py"
cat > "$PROJECT_NAME/__main__.py" <<EOL
def main():
    print("Welcome to $PROJECT_NAME!")

if __name__ == "__main__":
    main()
EOL
echo "Source directory created with __main__.py."

# Step 11: Create Root-Level Python Script
cat > "$PROJECT_NAME.py" <<EOL
from $PROJECT_NAME.__main__ import main

if __name__ == "__main__":
    main()
EOL
echo "Root-level script $PROJECT_NAME.py created."

# Step 12: Add Sample README.md
cat > README.md <<EOL
# $PROJECT_NAME

## Overview
Provide a brief description of your project here.

## Requirements
- Python 3.8 or newer is required.
- Ensure \`pip\` is installed and available in your environment.

## Installation
To set up the project, activate the virtual environment and install dependencies:
\`\`\`bash
source .venv/bin/activate
pip install -r requirements.txt
\`\`\`

## Directory Structure

The project follows this structure:

\`\`\`
$PROJECT_NAME/
├── .git/
├── .gitignore
├── .venv/
├── LICENSE.md
├── pyproject.toml
├── README.md
├── requirements.txt
├── $PROJECT_NAME.py            # Root-level script for running the application
├── $PROJECT_NAME/              # Source code directory
│   ├── __init__.py
│   └── __main__.py             # Entry point for the application
└── tests/                      # Tests directory
    ├── __init__.py
    └── test_placeholder.py     # Placeholder test file
\`\`\`

## Running the Application

There are two ways to run the application:

1. **Using the Root-Level Script**:
    \`\`\`bash
    python $PROJECT_NAME.py
    \`\`\`

2. **Using the Module Entry Point**:
    \`\`\`bash
    python -m $PROJECT_NAME
    \`\`\`

Both methods execute the \`main()\` function defined in \`$PROJECT_NAME/__main__.py\`.

## Running Tests

The script sets up a \`tests/\` directory with a placeholder test file. You can run all tests using \`pytest\`:

1. Activate the virtual environment:
    \`\`\`bash
    source .venv/bin/activate
    \`\`\`

2. Run tests:
    \`\`\`bash
    pytest
    \`\`\`

You can add more test files to the \`tests/\` directory as your project grows.

## Regenerating Requirements

If you add or update dependencies, regenerate the \`requirements.txt\` file:
\`\`\`bash
pip freeze > requirements.txt
\`\`\`

## Features
- Feature 1
- Feature 2
EOL
echo "Sample README created."

# Step 13: Add a LICENSE file
cat > LICENSE.md <<EOL
[... Fill in your LICENSE details here ...]
EOL
echo "LICENSE.md created with a placeholder."

# Final Message
echo "Project $PROJECT_NAME set up successfully with Python version $PYTHON_VERSION!"
