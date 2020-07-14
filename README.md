# Angular CLI development environment

This docker image is a fully fledged angular cli development environment.

whenthe container starts it will automaticaly run the [docker-entrypoint.sh](docker-entrypoint.sh) script in this script it runs npm install and then npm start.

## Setup of new project

    docker run -p 4200:4200 -it --entrypoint /bin/bash --rm --name project-name-here -v ${PWD}:/project gavinharrison/angular

From here you can run `ng new` to create a new angular project.

If you start the container without setting the --entrypoint to /bin/bash.

## Development of an existing project

First open a terminal window and navigate to the project directory

Update your package.json file `"start": "ng serve",` to `"start": "ng serve --host 0.0.0.0",`

adding the --host:0.0.0.0 to the ng serve is to allow your computer to access the container because by default ng serve only serves to the localhost and seen as we are connecting over the docker proxy the connection is not local to the container once it will not work

Now run the following to start up the container and start serving your angular project then visit <http://localhost:4200> to access your angular app.

    docker run -p 4200:4200 --rm --name project-name-here -v ${PWD}:/project gavinharrison/angular

command break down
`-p 4200:4200` this is the port number binding between the host and container first value is the host and the second is the conainer. port 4200 is the default angular cli web server. you could change this to `-p 80:4200` if you would access the container on the default http port on e.g. `http://localhost/`

`--rm` this removes the container once the container is stopped. Remove this from the above command if you would like the container to persist.

`--name project-name-here` this is an easy to remember name for the conatainer for when trying to access the container later to run ng commands.

`-v ${PWD}:/project` this is to connect the current directory to the projects folder within the docker container to allow local developmnet for the applications files.

Now to execute ng commands open another terminal and run the following. This will give you a shell in the container directaly.

    docker exec -it project-name-here /bin/bash

## Troubleshooting

If you are getting a unable to connect or connection was dropped then make sure that the `ng serve` command has the argument `--host 0.0.0.0` this will attach the web server to the container to be accessible externaly of the container as by default the web server restricts to localhost only connections and as we are connecting through the docker proxy we are not localhost hence the reason to opening it to all connections.

If you get the below error this is because the docker-entrypoint.sh script was unable to locate the package.json file during the instalation of the node_modules.

    $docker run -p 4200:4200 -it --rm --name project-name-here -v ${PWD}:/project gavinharrison/angular /bin/bash

    npm WARN saveError ENOENT: no such file or directory, open '/project/package.json'
    npm notice created a lockfile as package-lock.json. You should commit this file.
    npm WARN enoent ENOENT: no such file or directory, open '/project/package.json'
    npm WARN project No description
    npm WARN project No repository field.
    npm WARN project No README data
    npm WARN project No license field.

    up to date in 0.414s
    found 0 vulnerabilities

    npm ERR! code ENOENT
    npm ERR! syscall open
    npm ERR! path /project/package.json
    npm ERR! errno -2
    npm ERR! enoent ENOENT: no such file or directory, open '/project/package.json'
    npm ERR! enoent This is related to npm not being able to find a file.
    npm ERR! enoent 

    npm ERR! A complete log of this run can be found in:
    npm ERR!     /root/.npm/_logs/2020-07-14T02_21_40_542Z-debug.log
