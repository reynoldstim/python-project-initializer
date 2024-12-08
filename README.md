# Python Project Initializer

A simple, customizable Bash script to bootstrap Python projects with a virtual environment, essential development tools, and a standard directory structure.

## Requirements

- **Bash**: The script is designed to run in a Bash-compatible shell.
- **Python**: Ensure Python 3.8 or newer is installed and available in your `PATH`.
- **Git**: Required for initializing the repository.

## Usage

1. Clone the repository:
    ```bash
    git clone https://github.com/reynoldstim/python-project-initializer.git
    cd python-project-setup-script
    ```

1. Make the script executable:

    ```bash
    chmod +x init_python_project.sh
    ```

1. Run the script:

    ```bash
    ./init_python_project.sh
    ```

    Follow the prompts to:

    Enter a project name.

    Specify the Python version (e.g., python3.9).
    
    Once completed, navigate to your project directory to start coding:

    ```bash
    cd <project-name>
    ```

## Directory Structure
The script generates the following project structure:

```bash
<project-name>/
├── .git/
├── .gitignore
├── .venv/
├── LICENSE.md
├── pyproject.toml
├── README.md
├── requirements.txt
├── <project-name>.py           # Root-level script for running the application
├── <project-name>/             # Source code directory
│   ├── __init__.py
│   └── __main__.py             # Entry point for the application
└── tests/                      # Tests directory
    ├── __init__.py
    └── test_placeholder.py     # Placeholder test file
```

## License
This project is licensed under the MIT License. See the LICENSE.md file for details.

## Contributions

Contributions, issues, and feature requests are welcome! Feel free to fork the repo and submit a pull request.
