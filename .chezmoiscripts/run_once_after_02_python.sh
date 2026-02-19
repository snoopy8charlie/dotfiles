#!/usr/bin/env bash

if [[ $CHEZMOI_OS == "windows" ]]; then
  echo "Execution paused. Install Python now."
  read -s -p "Press [Enter] to resume..."

  if command -v python >/dev/null 2>&1; then
      echo "Python is installed and executable."
  else
      echo "Error: python not found in PATH."
      exit 1
  fi

  python -m pip install -U pip

fi

if [[ $CHEZMOI_OS == "linux" ]]; then
  echo "Execution paused. Install Python now."
  read -s -p "Press [Enter] to resume..."

  if command -v python >/dev/null 2>&1; then
      echo "Python is installed and executable."
  else
      echo "Error: python not found in PATH."
      exit 1
  fi

  python -m pip install -U pip
fi

pip install djlint ruff ty
