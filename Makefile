# Variables
.PHONY: install test lint format clean train evaluate help

PYTHON := python3
PIP := pip
PROJECT_NAME := siem_ml

# Default target
.DEFAULT_GOAL := help

help:
	@echo "SIEM ML Project - Available Commands:"
	@echo "  make install        - Install dependencies"
	@echo "  make train          - Train ML model"
	@echo "  make evaluate       - Evaluate model performance"
	@echo "  make test           - Run unit tests"
	@echo "  make lint           - Lint code (flake8)"
	@echo "  make format         - Format code (black)"
	@echo "  make clean          - Remove cache files"
	@echo "  make data-prepare   - Prepare/preprocess data"

# Install dependencies
install:
	$(PIP) install -r requirements.txt

# Prepare data
data-prepare:
	$(PYTHON) -m src.data.load

# Train model
train:
	$(PYTHON) -m src.models.train --config configs/train.yaml

# Evaluate model
evaluate:
	$(PYTHON) -m src.models.evaluate --config configs/train.yaml

# Run tests
test:
	$(PYTHON) -m pytest tests/ -v

# Lint code
lint:
	flake8 src/ tests/ --max-line-length=100

# Format code
format:
	black src/ tests/

# Clean cache
clean:
	find . -type d -name __pycache__ -exec rm -r {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .coverage

# Run full pipeline
pipeline: install data-prepare train evaluate
	@echo "✅ Full pipeline completed!"
