# Shiny app for USS pensions

## Info

The modelling for this was developed by Neil Davies and ported to an R package here [https://github.com/explodecomputer/USSpensions](https://github.com/explodecomputer/USSpensions).

This is a shiny wrapper for the functions in that package.


## Running the app locally

Clone the repository

```
git clone https://github.com/explodecomputer/USSpensions-shiny.git
```

Install the dependencies

```
devtools::install_github("explodecomputer/USSpensions")
install.packages("shiny")
install.packages("shinydashboard")
```

Then in R when the work directory is `path/to/USSpensions-shiny`, run:

```
library(shiny)
runApp()
```

## Deploying to server

There are two parts to updating the website:

If any changes are made to the shiny app then increment the version number by running

```bash
./update_version.sh <1/2/3>
```

The shiny app is deployed as a Docker container on `crashdown.epi.bris.ac.uk`. To update either because of changes to the app or the data dictionary, ssh into the server, clone the repository

```bash
git clone git@github.com:explodecomputer/USSpensions-shiny.git
```

Then build and deploy

```bash
cd USSpensions-shiny
./release.sh
```

## Kubernates deployment

1. Setup `kubectl` on local machine
2. `kubectl apply -f uss-pensions-shiny_deployment.yml`
3. `kubectl apply -f uss-pensions-shiny_service.yml`
4. Check with `kubectl describe [deployment/service] uss-pensions-shiny`

Updating when image updates:

1. List existing pods `kubectl get deployments`
2. Delete each of them `kubectl delete deployment uss-pensions-shiny-deployment`

They should be automatically replaced
