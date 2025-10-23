# Helm-chart

This repo contains a solution to build a CI/CD pipeline that automates testing, 
building, releasing, and deploying Backend and Frontend applications with their 
databases to a Kubernetes cluster.

## Content

- [Helm-chart](#helm-chart)
  - [Content](#content)
  - [Repo structure](#repo-structure)
  - [Requirements](#requirements)
  - [Quick start](#quick-start)
    - [Docker](#docker)
    - [Helm](#helm)
  - [CI/CD](#cicd)
    - [Pull requests](#pull-requests)
    - [Push in main](#push-in-main)
  - [Environments](#environments)
    - [Docker environments](#docker-environments)
    - [Helm environments](#helm-environments)
    - [CI/CD environments](#cicd-environments)
    - [CI/CD secrets](#cicd-secrets)
  - [Troubleshooting](#troubleshooting)

## Repo structure

```sh
backend
├── app
│   └── routes
└── tests
frontend
helm-chart
└── templates
```

## Requirements

* [Docker](https://docs.docker.com/engine/install/debian/) >= v28
* Docker-compose >= v2.40.0
* [Minikube](https://minikube.sigs.k8s.io/) or other Kubernetes provider
* [kubectl](https://kubernetes.io/docs/tasks/tools/) >= v5.7
* [Helm](https://helm.sh/) >= v3.19
* GitHub account for CI/CD
* Optional: [self-hosted runner for GitHub](https://docs.github.com/en/actions/reference/runners/self-hosted-runners)

## Quick start

### Docker

Before run please provide required [environments](#docker-environments). Start 
application in Docker:

```sh
docker compose up -d
```

### Helm

Before run please provide required secret [environments](#helm-environments). Starting 
of helm chart might be more then one minute, please wait for correct work. Start 
application in Helm:

```sh
helm install helm-chart --generate-name
```

Verify cluster:

```sh
kubectl get pod
```

Also you can render manifest for review:

```sh
helm template helm-chart --debug
```

## CI/CD

### Pull requests

Opening a pull request starts the CI pipeline: it performs code linting and runs 
automated tests to validate the changes.

### Push in main

Pushing to the main branch triggers the release pipeline:

* Build container images and push them to the container registry when the image tag 
  is new.
* Package and publish a Helm chart artifact that references the newly built 
  image tags.
* Deploy the published Helm artifact to the remote Kubernetes cluster, performing 
  a `helm upgrade --install`.

## Environments

### Docker environments

You can specify your own environments parameters in `.env` file.

```yml
MYSQL_USER:             default: user
MYSQL_PASSWORD:         default: user
MYSQL_ROOT_PASSWORD:    default: root
MYSQL_HOST:             default: mysql_db
MYSQL_DB:               default: app_db
MYSQL_PORT:             default: 3306
REDIS_HOST:             default: redis
REDIS_PORT:             default: 6379
FE_HOST:                default: front:80
API_URL:                default: http://app.local:5000
```

### Helm environments

You can specify single environment variable using:

```sh
helm upgrade --install helm-chart ./chart --set <your env>
```

or edit deployment file with environment.

```yml
MYSQL_USER:             default: user
MYSQL_PASSWORD:         default: user
MYSQL_ROOT_PASSWORD:    default: root
MYSQL_HOST:             default: {{ .Release.Name }}-mysql
MYSQL_DB:               default: app_db
MYSQL_PORT:             default: 3306
REDIS_HOST:             default: {{ .Release.Name }}-redis
REDIS_PORT:             default: 6379
FE_HOST:                default: {{ .Release.Name }}-frontend:80
API_URL:                default: http://app.local:5000
```

### CI/CD environments

```yml
BACKEND_DIR:            default: backend
FRONTEND_DIR:           default: frontend
HELM_DIR:               default: helm-chart
RELEASE_DEST_DIR:       default: release
BACKEND_IMAGE_NAME:     default: antoni0832/backend-app
FRONTEND_IMAGE_NAME:    default: antoni0832/frontend-app
```

### CI/CD secrets

```yml
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
KUBECONFIG
```

## Troubleshooting

To view working of your containers in docker, run this command:

```sh
docker ps
```

You should see at least 5 containers.

Stop containers in Docker:

```sh
docker compose down
```

Run container shell in Docker:

```sh
docker exec -it <container_id> /bin/sh
```

Debug and lint helm chart:

```sh
helm template . --debug
```

Get created pods:

```sh
kubectl get pod
```

Get all resources:

```sh
kubectl get all --all
```

Detail review of specific resource:

```sh
kubectl describe <resource>
```

Check Kubernetes config:

```sh
kubectl config view --flatten --minify
```
