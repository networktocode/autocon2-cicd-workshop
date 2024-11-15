## Lab 4 Source Code Checks

During the first 3 labs you've utilized a new project and built upon it. For labs 4-6 we will use a project that we've created for you, this should allow us to focus more on the pipelines and less of the copy/pasting of code.

## Fork GitLab Repository

Navigate to the CICD boilerplate project located at: https://gitlab.com/jeffkala/ac2-cicd-workshop

Click on the `Fork` button which is in the top right of the page.

- Select a Namespace for the Project to be forked into: (should be your GitLab username).
- Make sure `Branches to include` is set to `all`.

![gitlab-fork-project](./images/gitlab-fork-project.png)

## Create Access Token and Update Git Remote

Now that you have your fork lets create a access token so we can push code into your fork later.

In GitLab UI navigate to Settings -> Access Tokens

![nav-access-token](./images/nav-access-token.png)

Save this token somewhere safe!

## Clone the GitLab Forked Project into Codespaces

Now clone the GitLab repo in to your codespace environment. This will allow everything to be managed from this single place.

```sh
@jeffkala ➜ /workspaces/autocon2-cicd-workshop-dev (jkala-work) $ git clone https://gitlab.com/jeffkala/ac2-cicd-workshop.git
Cloning into 'ac2-cicd-workshop'...
remote: Enumerating objects: 597, done.
remote: Counting objects: 100% (484/484), done.
remote: Compressing objects: 100% (467/467), done.
remote: Total 597 (delta 298), reused 0 (delta 0), pack-reused 113 (from 1)
Receiving objects: 100% (597/597), 212.95 KiB | 9.68 MiB/s, done.
Resolving deltas: 100% (324/324), done.
```

Once the forked repository is cloned into codespace you will see it in your files.

![codespace-with-fork](./images/codespace-with-fork.png)

Next, create an access token. The scopes are in the screenshot below. Navigate to Settings -> Access tokens from your GitLab forked project.

![access-token](./images/access-token-generated.png)


Finally, in set your origin with your HTTP basic authentication.

From within the `ac2_cicd_workshop` directory.

```sh
@jeffkala ➜ /workspaces/autocon2-cicd-workshop-dev/ac2-cicd-workshop/ac2_cicd_workshop (Lab_4_Source_Code_Checks) $ git remote set-url origin https://<gitlab-user>:<glpat>@gitlab.
com/jeffkala/ac2-cicd-workshop.git
```

## Run Containerlab Topology and Update the Nornir Inventory

Due to the nature of GitHub's codespaces; and the docker networking within; there is an initial requirement to update the Nornir inventory file.

1. Execute the containerlab deploy command which based on the topology file will auto assign mgmt interfaces to the lab equipment.

> [!INFO]
> If you already have a topology running from prior labs, kill that first with `sudo containerlab destroy --topo ceos-lab.clab.yml`

Navigate to clab directory:
```
@jeffkala ➜ /workspaces/autocon2-cicd-workshop-dev (jkala-work) $ cd clab/
```

Start the topology:
```
@jeffkala ➜ /workspaces/autocon2-cicd-workshop-dev/clab (jkala-work) $ sudo containerlab deploy --topo ceos-lab.clab.yml 
INFO[0000] Containerlab v0.59.0 started                 
INFO[0000] Parsing & checking topology file: ceos-lab.clab.yml 
< omitted >
INFO[0083] Adding containerlab host entries to /etc/hosts file 
INFO[0083] Adding ssh config for containerlab nodes     
+---+---------+--------------+--------------+------+---------+---------------+--------------+
| # |  Name   | Container ID |    Image     | Kind |  State  | IPv4 Address  | IPv6 Address |
+---+---------+--------------+--------------+------+---------+---------------+--------------+
| 1 | ceos-01 | 83980f93c345 | ceos:4.32.0F | ceos | running | 172.17.0.6/16 | N/A          |
| 2 | ceos-02 | d001c87a784e | ceos:4.32.0F | ceos | running | 172.17.0.4/16 | N/A          |
| 3 | ceos-03 | 603aacedc2e0 | ceos:4.32.0F | ceos | running | 172.17.0.5/16 | N/A          |
| 4 | ceos-04 | 7ac8e8f17ecd | ceos:4.32.0F | ceos | running | 172.17.0.3/16 | N/A          |
+---+---------+--------------+--------------+------+---------+---------------+--------------+
```

2. Now that the lab has been deployed in the Codespace environment, and we have the mgmt IPs of the equipment we must update the Nornir inventory host file with the assigned IPs.

3. To get started we will checkout the GitLab branch called `Lab_4_Source_Code_Checks` where we will update our Nornir inventory and push the code up to run the code checks.

4. Navigate and Checkout the Working Branch

From within the Codespace terminal change into the newly cloned fork.

```sh
cd ../ac2-cicd-workshop/ac2_cicd_workshop/
```

Next, checkout the `Lab_4_Source_Code_Checks` branch.


```sh
git switch Lab_4_Source_Code_Checks
```

5. Now navigate to ac2_cicd_workshop --> inventory --> hosts.yml

Update the host definitions `hostname` field with the correct IP address from the containerlab deploy command output.

For example the updates would look like this.
```yml
---
ceos-01:
  hostname: "172.17.0.6"
... omitted ...
ceos-02:
  hostname: "172.17.0.4"
... omitted ...
ceos-03:
  hostname: "172.17.0.5"
... omitted ...
ceos-04:
  hostname: "172.17.0.3"
... omitted ...
```

## Review the Existing Pipeline

Lab 4 is all about the "project" level source code checks.

When you open the `.gitlab-ci.yml` file you will notice we have some defaults, workflow details, `before_script` definitions, stages, and more..

Next, we will look at the `stages:` section which tells our pipeline what stages and what order they should be executed in.

```yml
stages:  # List of stages for jobs, and their order of execution
  - "lab-4-lint-and-format"
  - "lab-4-pytest"
```

You will finally see the `include:` section which is where we can add additonal gitlab-ci files. We will add more files to this section throughout labs 5 and 6.

```yml
include:
  - local: ".gitlab/ci/lab-4-includes.gitlab-ci.yml"
```

Lets now review the details of that included file to see what source code checks we're running.

1. Navigate to `.gitlab/ci/lab-4-includes.gitlab-ci.yml` within the forked repository.
2. Notice that each of our jobs have a `name`, but more importantly it has a `stage` where that job name and detail is linked to a stage we had in our `.gitlab-ci.yml` file.

```yml
yamllint-job:
  stage: "lab-4-lint-and-format"
```
Each job then has an execution strategy and commands.

```yml
yamllint-job:
  stage: "lab-4-lint-and-format"
  script:
    - "echo 'Linting Nornir YAML inventory files..'"
    - "poetry run yamllint . --config-file .yamllint.yml --strict"
```
In this yamllint-job we're echoing a simple description, followed by running yamllint from within our poetry environment.

3. Notice this file has all our other source code checks we want to enforce. Some simple explanations are below.

- **yamllint** - Validate all our YAML files in the project are formatted to our standards, e.g. all strings should be wrapped in double quotes.
- **j2lint** - Our source code has a Jinja2 templates directory. This directory holds all the templates we will use to generate our Arista configurations. J2Lint validates these template files follow best practices.
- **ruff** - We use ruff in two stages. The first lints and formats our source codes python files.  The second does ruff formatting checks to find python antipatterns etc.
- **pytest** - Finally, we have some basic unittest in the project that are unittest validating the source code itself. This checks only for tests under the `tests/unit` folder.

As you can see this is a ton of source code checks. It keeps our projects clean, and following best practices for multiple different file types and frameworks.

## Push our Changes and Run the Pipeline

Now that we understand lab 4, and the source code checks, lets update and run the pipeline.

By default, the runner we created for another project is available but not enabled to run jobs for this project, so we will need to enable it by going to "Settings -> CI/CD -> Runners" find the runner and click on "Enable for this project":   

![enable-runner](images/enable-runner.png)

These are the two assumptions before you should push your code up:

1. Ensure you've updated your Nornir inventory files from [here](README.md#run-containerlab-topology-and-update-the-nornir-inventory).
2. Navigate to the main `.gitlab-ci.yml` pipeline file and update your tag to what you deployed in the first lab.

```yml
---
default:
  image: "allprojeff66/ac2-cicd-workshop:latest"
  tags:
    - "jeff-kala-01"  # Update using CICD Runner Tag you used!
```

3. Commit and Push your code up!

```sh
git add -A;git commit -m "lab4 updates";git push -u origin Lab_4_Source_Code_Checks
```

4. Go into your GitLab UI and navigate to the forked project.
5. Navigate to Builds from the side menu and click on Pipelines.

![nav-pipeline](./images/nav-build-pipelines.png)

6. Watch your Pipeline run

![pipeline-overview](./images/pipeline-overview.png)

![pipeline-details](./images/pipeline-details.png)
