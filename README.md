# Blockchain Data Large Language Model

## Project Overview

A sophisticated chatbot platform designed to provide real-time insights and answers to questions about blockchain data and news across multiple blockchain networks. This system leverages advanced data engineering, machine learning, and natural language processing techniques to deliver accurate, contextual responses about blockchain transactions, smart contracts, market trends, and industry developments.

## Key Features

- **Multi-Chain Data Analysis**: Processes and analyzes data from Bitcoin, Ethereum, Solana, and BNB Smart Chain
- **Domain Expertise**: Improves response quality through model fine-tuning on common blockchain terms
- **Price Prediction**: Forecasts cryptocurrency price movements using machine learning models trained on historical data
- **Real-Time News Integration**: Incorporates latest blockchain news and social media trends
- **Natural Language Understanding**: Interprets complex blockchain queries in conversational language
- **Contextual Response Generation**: Provides accurate, relevant answers with supporting data

## Technical Architecture

The system is built on a modern data lakehouse architecture with three main components:

1. **Data Ingestion & Processing Layer**: Collects blockchain data through The Graph and social media content via Twitter API, processed using Apache Spark and Apache Airflow for batch and Kafka and Spark Streaming for streaming workloads. Performs data validation through Great Expectations. 
   
2. **Storage & Analytics Layer**: Organizes data using Apache Iceberg and Project Nessie for versioning, with PostgreSQL for structured data and vector embeddings for semantic search.

3. **Machine Learning Layer**: Utilizes Scikit-learn to build and train predictive models for cryptocurrency price forecasting, with Kubeflow orchestrating the ML pipeline from feature engineering to model deployment.

4. **Large Language Model Layer**: Employs a self-hosted open source model and LangChain for natural language processing, with RAG (Retrieval Augmented Generation) techniques to ground responses in factual blockchain data. Implements LoRA adapters for efficient model fine-tuning and DeepEval for comprehensive model evaluation and validation.

5. **Infrastructure & Observability Layer** The entire platform runs on Kubernetes in Google Cloud Platform, with comprehensive monitoring using Prometheus, Grafana and Loki. Continuous integration and continouous deployment are orchestrated by GitHub Actions and ArgoCD respectively.

For a full list of technologies used, please see [technologies](./technologies.md).

## Value Proposition

This chatbot bridges the knowledge gap in the blockchain space by:

- Simplifying access to complex blockchain data for both technical and non-technical users
- Providing factual, up-to-date information in an increasingly noisy information landscape
- Enabling deeper insights through cross-chain data correlation and analysis
- Providing data-driven price predictions to inform investment decisions
- Serving as a reliable research assistant for blockchain developers, analysts, and enthusiasts
