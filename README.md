# RaBot -- Learning by coding a rabbit!

RaBot is a project aiming at creating a vivid and interactive environment for children to learn computer programming, it's also our project for the course <Software Engineering> and it might be used by JiSuanKe.com for further development.

## Details
The programming language children use to control the rabbit will be [CoffeeScript](http://coffeescript.org/) (or something based on it). Users need to program their rabbit to accomplish various tasks, and finally let them eat carrots~

## Build the frontend
Make sure you have the followings installed: **npm**, **grunt-cli**, **bower** (Remember to use **npm -g** to perform a global installation)
In addition, install **Ruby** and gem to install **sass**

Use the following commands to build:

`npm install`

`npm run build`

Use the following command to serve the frontend:

`npm run server`

This will run a web server at port 9000, and it will contact with backend server
via reverse proxy at port 8000.

## Test backend server

Django support both Python2 and Python3. You can deploy the server in a virtualenv, note the folder name need to be **venv**.

Note that if you don't work in a virtualenv, ./manage.py will not work for you. Use **python manage.py** instead.

Use the following commands to install python dependencies:

`cd backend`

`pip install -r requirements.txt`

Use the following command to run the development server:

`python manage.py runserver`

## Adding stages and users

Currently, there is no interface yet to register or adding a stage, but Django
management script is used to add some built-in users and stages. To perform them
use:

`python manage.py addstages`

`python manage.py addusers`

## Unit Tests

### Frontend

Frontend unit tests is accomplish via **jest**, You can run test, use:

`npm run test`

### Backend
Backend unit tests is based-on Django's unit test module (which is a wrapper
of python's unittest module).

## Team members
* 廖亦阳
* 梁泽宇
* 刘家昌
* 谭思楠
