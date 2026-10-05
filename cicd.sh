#!/bin/bash

# ==========================================
# Configuration
# ==========================================

RESOURCE_GROUP="AZ104-sturvs"
RG_LOCATION="eastus"

PLAN_NAME="fly-plan"
PLAN_LOCATION="westus2"
PLAN_SKU="B1"

WEBAPP_NAME="jegan-test-node-1"
RUNTIME="NODE:24-lts"

ZIP_FILE="app.zip"


# ==========================================
# Package Application
# ==========================================

zip -r app.zip . \
  -x "node_modules/*" \
     ".git/*" \
     ".next/*" \
     "app.zip"

# ==========================================
# Step 0 - Create Resource Group
# ==========================================

az group create \
  --name "$RESOURCE_GROUP" \
  --location "$RG_LOCATION"


# ==========================================
# Step 1 - Create App Service Plan
# ==========================================

az appservice plan create \
  --name "$PLAN_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$PLAN_LOCATION" \
  --sku "$PLAN_SKU" \
  --is-linux


# ==========================================
# Step 2 - Create Web App
# ==========================================

az webapp create \
  --name "$WEBAPP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --plan "$PLAN_NAME" \
  --runtime "$RUNTIME"


# ==========================================
# Step 3 - Enable Build During Deployment
# ==========================================

az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --settings SCM_DO_BUILD_DURING_DEPLOYMENT=true


# ==========================================
# Step 4 - Deploy Application
# ==========================================

az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --src-path "$ZIP_FILE" \
  --type zip
