# How to run Robot tests

## Creation of virtual environment

Before creating the virtual environment, you will need to install **python** on your local
machine. After that if you are using a windows/linux machine you should need to execute
the following command 

```
python -m venv .venv
```

To activate the venv on a windows machine, you should execute the following command 

```
.venv\Scripts\Activate.ps1
```

## Install dependencies

Inside the environment, we just created in the step above, execute the following
command

```
pip install -r requirements.txt
```

## Execute Robot Tests

To execute the robot tests in this project, you can provide the BASE_URL variable with either the prod or dev
URL based on which environment you want to test

```
python -m robot --variable BASE_URL:http://localhost:3000/prod .\ChallengeTestSuite\
```

If the BASE_URL variable is not filled, it defaults to the DEV url, you can change the default value on 
env_variables.py file

```
python -m robot .\ChallengeTestSuite\
```