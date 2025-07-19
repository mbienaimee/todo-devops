# To-Do DevOps Application

This repository contains a full-stack To-Do application, designed to demonstrate containerization, Infrastructure as Code (IaC) with Terraform, and deployment to Azure Container Apps.

## React + Vite Frontend Setup

This project was bootstrapped with [React](https://react.dev/) and [Vite](https://vitejs.dev/).

This template provides a minimal setup to get React working in Vite with HMR (Hot Module Replacement) and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

### Expanding the ESLint configuration

If you are developing a production application, we recommend using TypeScript with type-aware lint rules enabled. Check out the [TS template](https://github.com/vitejs/vite/tree/main/packages/create-vite/template-react-ts) for information on how to integrate TypeScript and [`typescript-eslint`](https://typescript-eslint.io) in your project.

---

## Project Structure

.
├── backend/ # Node.js backend application
├── todo/ # React frontend application (named 'todo' in your Dockerfile)
├── terraform/ # Terraform configurations for Azure infrastructure
│ └── azure/
│ └── main.tf
├── compose.yaml # Docker Compose for local development environment
├── Dockerfile # Multi-stage Dockerfile for building frontend and backend images
└── README.md # This file
└── phase.md # Assignment submission details (to be created/updated)

## Getting Started

To get this application up and running, you have two main options:

1.  **Local Development:** Run the application on your local machine using Docker Compose.
2.  **Cloud Deployment:** Deploy the application to Azure Container Apps.

---

## Local Development Setup (Docker Compose)

This section guides you on how to run the application locally using Docker Compose.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running.

### Steps

1.  **Clone the Repository:**

    ```bash
    git clone https://github.com/mbienaimee
    cd todo-devops
    ```

2.  **Build and Run with Docker Compose:**
    Navigate to the root of the project where `compose.yaml` is located.

    ```bash
    docker-compose -f compose.yaml up --build
    ```

    This command will:

    - Build the Docker images for both your frontend and backend services.
    - Start the backend service (Node.js).
    - Start the frontend service (React app served by Nginx).

3.  **Access the Application:**
    Once the services are up and running, open your web browser and navigate to:
    `http://localhost`

    You should see the To-Do application.

4.  **Stop the Application:**
    To stop the running services, press `Ctrl+C` in your terminal. To stop and remove the containers, networks, and volumes:
    ```bash
    docker-compose -f compose.yaml down
    ```

---

## Cloud Deployment Setup (Azure Container Apps)

This section details how to deploy the application to Azure using Terraform for infrastructure and Azure CLI for deployment.

### Prerequisites

- [Azure Account](https://azure.microsoft.com/free/)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and logged in (`az login`).
- [Terraform](https://www.terraform.io/downloads.html) installed.
- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running.

### Deployment Steps

#### 1. Login to Azure and Azure Container Registry (ACR)

1.  **Log in to Azure CLI:**

    ```bash
    az login
    ```

    Follow the browser prompts to log in.

2.  **Set your Azure Subscription (if you have multiple):**

    ```bash
    az account set --subscription "YOUR_AZURE_SUBSCRIPTION_ID_HERE"
    ```

    (Replace `YOUR_AZURE_SUBSCRIPTION_ID_HERE` with your actual subscription ID).

3.  **Log in to your Azure Container Registry (ACR):**
    This command authenticates your local Docker client with your ACR. Replace `YOUR_ACR_NAME_HERE` with your actual ACR name (e.g., `tododevopsregistry`).
    ```bash
    az acr login --name YOUR_ACR_NAME_HERE
    ```
    You should see "Login Succeeded".

#### 2. Provision Azure Infrastructure with Terraform

1.  **Navigate to your Terraform directory:**

    ```bash
    cd terraform/azure
    ```

2.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

3.  \*\*Review the Plan (Optional but Recommended):
    This shows what Terraform will create.

    ```bash
    terraform plan
    ```

4.  **Apply the Terraform Configuration:**
    This will create all the necessary Azure resources.
    ```bash
    terraform apply
    ```
    Type `yes` when prompted.
    **IMPORTANT:** At the end of `terraform apply`, Terraform will output several values, including sensitive data like `cosmosdb_connection_string`, `acr_admin_username`, and `acr_admin_password`. **Copy these values securely; you will need them for the deployment steps and should treat them as secrets. Do NOT commit them to Git.**

#### 3. Build and Push Docker Images to ACR

1.  **Navigate back to your project root directory:**

    ```bash
    cd ../.. # This assumes you are in terraform/azure
    ```

2.  **Build the Backend Docker Image:**
    This uses the `backend-final` stage of your multi-stage `Dockerfile`. Replace `YOUR_ACR_NAME_HERE` with your actual ACR name.

    ```powershell
    docker build -t YOUR_ACR_NAME_HERE.azurecr.io/mbienaimee/todo-backend:latest --target backend-final .
    ```

3.  **Push the Backend Docker Image to ACR:**
    Replace `YOUR_ACR_NAME_HERE` with your actual ACR name.

    ```powershell
    docker push YOUR_ACR_NAME_HERE.azurecr.io/mbienaimee/todo-backend:latest
    ```

4.  **Build the Frontend Docker Image:**
    This uses the `frontend-nginx` stage of your multi-stage `Dockerfile`. Replace `YOUR_ACR_NAME_HERE` with your actual ACR name.

    ```powershell
    docker build -t YOUR_ACR_NAME_HERE.azurecr.io/mbienaimee/todo-frontend:latest --target frontend-nginx .
    ```

5.  **Push the Frontend Docker Image to ACR:**
    Replace `YOUR_ACR_NAME_HERE` with your actual ACR name.
    ```powershell
    docker push YOUR_ACR_NAME_HERE.azurecr.io/mbienaimee/todo-frontend:latest
    ```

#### 4. Deploy Container Apps to Azure

Now you will deploy your Docker images as Azure Container Apps. Ensure you are still in your **project root directory**.

1.  **Define Cosmos DB Connection String Variable (PowerShell):**
    First, set the Cosmos DB connection string (copied securely from `terraform apply` output) into a PowerShell variable.

    ```powershell
    $cosmosDbConnectionString = "YOUR_COSMOSDB_CONNECTION_STRING_FROM_TERRAFORM_OUTPUT_HERE"
    ```

2.  **Create the Backend Container App:**
    This command deploys your backend and provides it with the Cosmos DB connection string.
    **Ensure you replace `YOUR_ACR_ADMIN_PASSWORD_FROM_TERRAFORM_HERE` with the actual password you copied securely, and `YOUR_ACR_NAME_HERE` with your ACR name.**

    ```powershell
    az containerapp create `
      --name todo-backend-app `
      --resource-group todo-devops-rg `
      --environment todo-devops-aca-env `
      --image YOUR_ACR_NAME_HERE.azurecr.io/mbienaimee/todo-backend:latest `
      --target-port 3001 `
      --ingress external `
      --query properties.configuration.ingress.fqdn `
      --registry-server YOUR_ACR_NAME_HERE.azurecr.io `
      --registry-username YOUR_ACR_NAME_HERE `
      --registry-password "YOUR_ACR_ADMIN_PASSWORD_FROM_TERRAFORM_HERE" `
      --env-vars COSMOSDB_CONNECTION_STRING=$cosmosDbConnectionString
    ```

    **IMPORTANT:** This command will output the **URL (FQDN)** of your backend application. **Copy this URL**, you'll need it for the frontend!

3.  **Create the Frontend Container App:**
    This command deploys your frontend and provides it with the URL of your backend.
    **Replace `YOUR_BACKEND_APP_FQDN_HERE` with the URL you copied from the previous step.**
    **Ensure you replace `YOUR_ACR_ADMIN_PASSWORD_FROM_TERRAFORM_HERE` with the actual password again, and `YOUR_ACR_NAME_HERE` with your ACR name.**

    ```powershell
    az containerapp create `
      --name todo-frontend-app `
      --resource-group todo-devops-rg `
      --environment todo-devops-aca-env `
      --image YOUR_ACR_NAME_HERE.azurecr.io/mbienaimee/todo-frontend:latest `
      --target-port 80 `
      --ingress external `
      --query properties.configuration.ingress.fqdn `
      --registry-server YOUR_ACR_NAME_HERE.azurecr.io `
      --registry-username YOUR_ACR_NAME_HERE `
      --registry-password "YOUR_ACR_ADMIN_PASSWORD_FROM_TERRAFORM_HERE" `
      --env-vars REACT_APP_BACKEND_URL="https://YOUR_BACKEND_APP_FQDN_HERE"
    ```

    **SUCCESS!** This command will output the **live public URL of your frontend application**.

### 5. Access Your Deployed Application

Open your web browser and navigate to the **Frontend App URL** that was outputted by the last `az containerapp create` command:

[link text](https://github.com/mbienaimee/todo-devops/pull/27)

---

## Cleaning Up Azure Resources

To avoid incurring continuous costs, you can destroy all the Azure resources provisioned by Terraform.

1.  **Navigate to your Terraform directory:**

    ```bash
    cd terraform/azure
    ```

2.  **Destroy the resources:**
    ```bash
    terraform destroy
    ```
    Type `yes` when prompted. This will remove all resources created by Terraform in your Azure subscription.

---

## Assignment Submission Details (for `phase.md`)

This section outlines the content for your `phase.md` file, as per the assignment instructions. You should create a separate file named `phase.md` in your repository root with this content.

```markdown
# Phase 2: IaC, Containerization & Manual Deployment Submission

## Live Public URL

The live URL for the manually deployed application:

[link text](https://todo-frontend-app.greenforest-62294cdc.southafricanorth.azurecontainerapps.io/)

## Screenshots of Successfully Provisioned Resources

(Insert screenshots here. You can take these from the Azure Portal, showing your resource group and the list of resources within it.)

## Link to Peer Review Pull Request

[link text](https://github.com/mbienaimee/todo-devops/pull/27)
```
