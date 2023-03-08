# System Golf

Prerequisites

- 2-Tier: https://github.com/jvalentino/sys-alpha-bravo
- 2-Tier with Load Balancing: https://github.com/jvalentino/sys-charlie
- 2-Tier with Load Balancing and Database Clustering: https://github.com/jvalentino/sys-delta
- 3-Tier: https://github.com/jvalentino/sys-echo-rest
- 3-Tier with Data Warehousing: https://github.com/jvalentino/sys-foxtrot

This is an example system that it used to demonstrate different architectural approaches as they relate to scalability. Its core functions are the following:

- The system shall allow a user to add documents
- The system shall version documents
- The system shall allow a user to download a document

This specific implementation takes our existing system, and moves it to the cloud on containerization:

- The front-end has been broken into its own independent application is separately load balanced.
- The backend is load balancer
- The database is clustered (assumed external)
- There is a separate database cluster that functions as long-term storage (assumed external)
- There is an additional backend that is used for handling managing the data warehouse
- **Everything is running on the cloud using both a containerization and externalization (SaaS) strategy**

## Previous System

**Data warehousing (Rating: a thousand consistently)**

A common problem that systems eventually run into given enough time, is that the more data stored in their system, the slower the systems perform. This is basically Relational Databases are not infinitely horizontally scalable. This had lead to what we call data warehousing. This is where the core system generally only contains data relevant to some time window (in years) relative to current, and a specialized database cluster is created for the purpose of historial inquiry. This is also the "big data" problem, which has its own solutions, but it is important to understand where it started.

[![01](https://github.com/jvalentino/clothes-closet-wiki/raw/main/wiki/step-6.png)](https://github.com/jvalentino/clothes-closet-wiki/blob/main/wiki/step-6.png)

Pros

- Backend and Database independent, allowing us have different optimized servers.
- Multple backends allows us to handle more load from users.
- A database cluster removes the database from being the solo bottlekneck.
- Session is maintained in the database, taking it out of memory.
- Separation between backend and frontend allows for slightly more load.
- Data is continually and selectively pruned from the system to mitigate sizing issues.

Cons

- Incentivizes a snowflake architecture by having to fine tune the server hardware differently.
- You are paying for that second instance even when you don't need it.
- The addition of database land tripled the budget in hardware costs.
- You had to double your budget again by adding a data warehouse.
- Usage of the data warehouse required specialized tools and knowledge.
- Core reliance on RDMS limits upper scalability.

## Current System

**SaaS (Rating: 10k)**

Use software as a service (SaaS) nearly all the time when available. This is because it significantly reduces your complexity and overhead. For example, you no longer need to be a X-Whatever-Database Clustering Expert, you just use it as a service from your cloud platform. However, where you might have been able to get away having devs logging into 20 or so servers to pull logs and gather metrics, that is no longer an option in this environment. That is because everything is dynamic, meaning it can go away if not in use. This forces you to have to being in:

- Monitoring - To know the health of everything
- Alerting - To know when human intervention is required
- Centralized Logging - To get to the logs in once place

[![01](https://github.com/jvalentino/clothes-closet-wiki/raw/main/wiki/step-8.png)](https://github.com/jvalentino/clothes-closet-wiki/blob/main/wiki/step-8.png)

Pros

- Backend and Database independent, allowing us have different optimized servers.
- Multple backends allows us to handle more load from users.
- A database cluster removes the database from being the solo bottlekneck.
- Session is maintained in the database, taking it out of memory.
- Separation between backend and frontend allows for slightly more load.
- Data is continually and selectively pruned from the system to mitigate sizing issues.
- Running the applications architecures on an elastic container platform allows them to scale up and down as needed.
- Using database as a service removed the need to deal with the details yourself.

Cons

- Core reliance on RDMS limits upper scalability.

# Architecture

## Key Concepts and Technologies

- Cloud Provider
- SaaS
- PaaS
- Image Registry
- Containerization
- Kubernetes
- Helm
- Docker
- Monitoring & Alerting
- Centralized Logging

## Production

With a now core reliance on Cloud with a focus on SaaS, the Production implementation is going to look a little different (with respect to Dev/Prod Parity) than our Development environments. This is largely do to that we get to a point where one can't run the entire system locally anymore due to its size, and thus work on a system in parts. Specifically, you don't expect the average developer to be running the entire monitoring stack locally, however someone working on the monitoring stack would need to. 

Consider that that when it comes to infrastructure like monitoring, logging, alerting, and data storage, the first rule of the cloud is "don't". More specifically, don't get in the business of hosting this stuff yourself, and instead rely on what your cloud provider has as SaaS. This is a tradeoff between cost and maintenance, being that implementing and maintain these infrastructures can be incredibly complicated, and generally require teams unto themselves. 

The resulting production architecture look like this:

![01](./wiki/01.png)

### Source Control (Git)

The basis of any system is source control, where every component is expected to be its own repository. As this is infrastructure, it is highly recommended that you rely on a third-party to provide your Git hosting, for example GitHub.com, bitbucket.com, etc. The reasoning is the same for the rest of infrastructure: setup, hosting, and maintenance is complicated and generally requires a dedicated team. That may not seem like much at first, but with all the new infrastructure we are adding it can quickly get out of control: Cloud First.

The specific expected repositories are:

- **sys-golf-ui** - The codebase for the ReactJS based UI, which uses an NPM build system, contains a Dockerfile for representing the container used for running it, Helm configurations for deploying it onto Kubernetes, and then the Pipeline as code for managing it all on the CI/CD system.
- **sys-golf-rest** - The codebase for the Spring Boot based backend, or restful services. It uses the Gradle build system, contains a Dockerfile for representing the container used for running it, the Helm configurations for deploying it onto Kubernetes, and then the Pipeline as Code for managing it all on the CI/CD system.
- **sys-golf-etl** - The codebase for the Spring Boot based ETL, or the thing that manages the data warehouse. It uses the Gradle build system, contains a Dockerfile for representing the container used for running it, the Helm configurations for deploying it onto Kubernetes, and then the Pipeline as Code for managing it all on the CI/CD system.
- **logging** - Because the logging is handled via SaaS, the purpose of this project is to contain the minimal configuration needed for setting it up and maintain it. This is always technology specific, but there will always be some minimal configuration and at least a single command-line thing to handle it.
- **monitoring** - Because the monitoring is handled via SaaS, the purpose of this project is to contain the minimal configuration needed for setting it up and maintain it. This is always technology specific, but there will always be some minimal configuration and at least a single command-line thing to handle it.
- **database (primary)** - Because the database is handled via SaaS, the purpose of this project is to contain the minimal configuration needed for setting it up and maintain it. This is always technology specific, but there will always be some minimal configuration and at least a single command-line thing to handle it.
- **database (secondary)** - Because the database is handled via SaaS, the purpose of this project is to contain the minimal configuration needed for setting it up and maintain it. This is always technology specific, but there will always be some minimal configuration and at least a single command-line thing to handle it.

### CI/CD

CI/CD in this context refers to the technology used to automate build, test, and deployment. As with the "Cloud First" principle, you want to avoid hosting this yourself at almost all costs. Tools like Jenkins can get extremely complicated when dealing with even mid-level scale, resulting in the need for having a dedicated team just for a single tool. Instead of having yet another dedicated team for yet another tool, it is instead recommended to leverage SaaS solutions such as Github Actions, BitBucket Pipelines, etc.

- **sys-golf-ui** - One or more pipelines for testing, building, and delivering the frontend application, the first of which is triggered on any code change to any branch.
- **sys-golf-rest** - One or more pipelines for testing, building, and delivering the REST services, the first of which is triggered on any code change to any branch.
- **sys-golf-etl** - One or more pipelines for testing, building, and delivering the ETL application, the first of which is triggered on any code change to any branch.
- **logging** - One or pipelines for managing whatever the SaaS centralized logging requires, which should be minimal.
- **monitoring** - One or pipelines for managing whatever the SaaS centralized monitoring requires, which should be minimal.
- **database (primary)** - One or pipelines for managing whatever the SaaS primary database requires, which should be minimal considering the schema is already automatically managed by the REST application.
- **database (secondary)** - One or pipelines for managing whatever the SaaS secondary database requires, which should be minimal considering the schema is already automatically managed by the ETL application.

### Image Registry

Because the core of our system is containerization, it is inevitable that we are going to have to generate and then store our own container (Docker Images). Specifically in this case, where are using a custom nginx container for the frontend and two different custom OpenJDK containers for the Spring Boot applications. To be able to pull them for usage in any containerization technology like Kubernetes, it is recommended that you use the registry provided by your cloud, for example ECR on AWS.

### Kubernetes

Instead of having to worry about load balancers, scaling, and container coordination, Kubernetes if a platform that manages this all for you. It is best to think of it as:

- **Cluster** - An abstract group of computing resources that are capable of running containers.
- **Namespaces** - A grouping of services, for example one for dev, one for prod, or sometimes it is best to have different namespaces for different aspects like logging.
- **Services** - An abstraction for running one or more pods.
- **Pods** - The actual underlying container, as orchestrated by a single service.

Since the commands and configuration for running things on Kubernetes can get complicated, it Is common to use Helm as a templating framework for managing the pages and pages of YAML for defining the Kubernetes runtimes.

In our production namespace we are running 4 services:

- **Frontend** - Which is the running of our sys-golf-ui project via its docker image, which additionally has a log forwarder built into that image to handle sending its logs to a central location.
- **Frontend** - Which is the running of our sys-golf-rest project via its docker image, which additionally has a log forwarder built into that image to handle sending its logs to a central location.
- **ETL** - Which is the running of our sys-golf-etl project via its docker image, which additionally has a log forwarder built into that image to handle sending its logs to a central location.
- **Dashboard** - This is a Kubernetes plugin for visualizing displaying the current Kubernetes namespace.

### More SaaS

In following the theme of "Cloud First" as we did for the Image Registry, CI/CD, and the hosting of Kubernetes itself, we are are relying on SaaS for our non-applications, specifically:

- **logging** - The recommendation is to use whatever the cloud provider offers, and if that is not sufficient there are other centralized solutions such as New Relic, Sumo Logic, etc.
- **monitoring** - The recommendation is to use whatever the cloud provider offers, and if that is not sufficient there are other centralized solutions such as New Relic, Dynatrace, etc.
- **Data storage** - The recommendation is to always use what the cloud provider offers, due latency (and cost) of attempting to store data outside of a specific cloud. A good example would be RDS on AWS.

## Local (Demonstration)

When it comes to demonstrating this system outside of production, and mostly because it is not cost effective for me to spin a large system up on AWS or Azure, I have the desired architecture running one instance of every locally. This is done by using Minikube as the local Kubernetes platform. Additionally, instead of running monitoring and logging and SaaS, I have set it up as well to run locally to both demonstrate what it looks like and give a taste of why you may not want to be maintaining those on your own.

![01](./wiki/02.png)

### Running it

Prerequisites

- git
- node
- java
- docker desktop
- IntelliJ
- pgadmin
- psql
- minikube
- helm

To install the above automatically, please use https://github.com/jvalentino/setup-automation.

#### (1) Start minikube

A script was provided to start Minikube with expanded memory and processing power:

```bash
./start-minikube.sh
```

Specifically that runs `minikube start --cpus 4 --memory 6144` because we are going to be running quite a bit of things.

#### (2) Launch the Kubernetes Dashboard

The following will run a temporary pod for the visual Kubernetes interface:

```bash
minikube dashboard
```

It will also automatically open a new browser window with it:

![01](./wiki/03.png)

There will be nothing running though.

#### (3) Build it all

Due to the complexity of having to build Java, Docker, and NPM artifacts, and went ahead and wrote a Gradle Task to do it all with one command:

```bash
./gradlew build
```

That takes 2-3 minutes, and will handle:

- Building the Spring Boot Jar for the REST app (sys-golf-rest)
- Building a Docker Image using the Spring Boot Jar for the REST app (sys-golf-rest), and pushing that image to the Minikube image cache
- Building the Spring Boot Jar for the ETL app (sys-golf-etl)
- Building a Docker Image using the Spring Boot Jar for the ETL app (sys-golf-etl), and pushing that image to the Minikube image cache
- Building the production site for the fronted (sys-golf-ui)
- Building a Docker Imaging using the production site for the frontend (sys-golf-ui), and pushing that image to the Minikube image cache

#### (4) Start Everything

The following script will start up everything one at a time, forward ports, and then verify that everything expected comes up. This takes about 7-8 minutes:

```bash
./start.sh
```

You know it is working if you can see all green circles on the Dashboard:

![01](./wiki/04.png)

Being that you aren't in reality going to be shutting down and starting up an entire system at the same time, and because you work on things one at a time, each individual aspect can be run, restarted, and verified all on its own.

#### (4) Seed Data

The following commands will set the state of both the primary and secondary database, and more specifically so you can log in using admin/37e098f0-b78d-4a48-adf1-e6c2568d4ea1

```bash
./gradlew deleteWarehouseDb loadMainDb
```

### Primary Database (pg-primary)

To re-install it, forward ports, and then verify it worked, use:

```bash
./start-db.sh
```

This works by using the Helm repository of `https://charts.bitnami.com/bitnami` for the configuration of `bitnami/postgresql` to run a single Postgres pod that is exposed on port 5432.

You can then verify it is working by using pgadmin:

![01](./wiki/05.png)

If the pod is running but you can't reach it, it is likely that the port forwarding died (which is common), so the following script can be used to re-forward the port and then check to make sure it worked:

```bash
./verify-db.sh
```

