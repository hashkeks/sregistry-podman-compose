# Singularity Registry Server - docker-compose edition
## QUICK GUIDE
In ./shub/settings/variable.sh change DOMAIN value to your domain and execute variable.sh

In ./shub/settings/secrets.py (do a cp of dummy_secrets before) change the SECRET_KEY. In ./shub/settings/config.py adjust admins, manager and help contact if needed. And also enable Plugins or Authentication possibilities.

After creating key(private) and certifications(dhparam and pem) place them in the right files: ./ssl/certs or ./ssl/private
In ./.env change the values of the name (default: domain_key.pem and domain_cert.pem)

Delete all .placeholder (find . | grep .placeholder | xargs rm), there just there for the file structures.

Have fun with your sregistry! :D



## What is podman-compose
Podman-compose is the podman equivalent to docker-compose, using the podman container engine. It allows for the creation of rootless containers running in user namespace. For more information see https://podman.io/ and https://github.com/containers/podman-compose

## What are the differences to the original Singularity Registry Server
This version of the Singularity Registry Server is set-up to work in a non-root environment. 
I **did not** change the code of the applications. 
I **did** change the folder structure and the docker-compose.yml file and provide documentation to make this setup run with podman-compose. 
This setup in it's current configuration is meant to be run with valid SSL certificates. You can change that by deactivating the corresponding settings in the docker-compose.yml and shub/settings/config.py files.
In the end you still have to make your configurations (like setting your services addresses, renaming your instance, enabling authentication, etc.) according to the original documentation which you can find at https://singularityhub.github.io/sregistry/

The differences in detail:
* Changed the docker-compose.yml
	* Volume paths are not taken from uwsgi directly, but are defined per service. Consquence: You don't need a nginx user on your host system anymore and don't have permissions problems after deactivating PAM again.
	* Volume mapping for PAM files changed.
	* Volume mapping for SSL certs changed.
	* Volume mapping for PostgreSQL database added, so it can save data persistently without initiating a backup procedure.
* A PAM folder with a 'shadow' file was added. You need to copy the information of configured users from your /etc/shadow into this file since rootless containers do not have access to the original /etc/shadow.
* An SSL directory with subdirectories was added to save and access cert files in the rootless environment.

## What to do besides doing the usual configuration
* You **need** to change the ownership of the sregistry/minio-images folder to the user that is used inside the minio container with the UID and GID 1.
To do so, execute the following command inside the sregistry folder:
```bash
podman unshare chown -R 1:1 minio-images
```
This will change the ownership to the UID that will be used in user namespace and represents the user with UID 1 inside the minio container.

* You can put your SSL cert and key into the according folders in the sregistry/ssl folder
* You can put your user info from /etc/shadow into sregistry/PAM/shadow

### Who worked on this
<table>
  <tr>
    <td align="center"><a href="https://github.com/hashkeks"><img src="https://avatars.githubusercontent.com/u/34633191?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Cedric Casper</b></sub></a><br /><a href="https://github.com/hashkeks" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/kkaftan"><img src="https://avatars.githubusercontent.com/u/74317121?v=4" width="100px;" alt=""/><br /><sub><b>Kevin Kaftan</b></sub></a><br /><a href="https://github.com/kkaftan" title="Code">💻</a></td>
  </tr>
</table>

## The following section is taken from the original Sregistry repo itself and does not have to do with our changes.

# Singularity Registry Server

[![status](https://joss.theoj.org/papers/050362b7e7691d2a5d0ebed8251bc01e/status.svg)](http://joss.theoj.org/papers/050362b7e7691d2a5d0ebed8251bc01e)
[![GitHub actions status](https://github.com/singularityhub/sregistry/workflows/sregistry-ci/badge.svg?branch=master)](https://github.com/singularityhub/sregistry/actions?query=branch%3Amaster+workflow%3Asregistry-ci)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1012531.svg)](https://doi.org/10.5281/zenodo.1012531)
[![fair-software.eu](https://img.shields.io/badge/fair--software.eu-%E2%97%8F%20%20%E2%97%8F%20%20%E2%97%8B%20%20%E2%97%8F%20%20%E2%97%8B-orange)](https://fair-software.eu)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-20-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

- [Documentation](https://singularityhub.github.io/sregistry)

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://vsoch.github.io"><img src="https://avatars0.githubusercontent.com/u/814322?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Vanessasaurus</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=vsoch" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=vsoch" title="Code">💻</a></td>
    <td align="center"><a href="tschoonj.github.io"><img src="https://avatars0.githubusercontent.com/u/65736?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Tom Schoonjans</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=tschoonj" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=tschoonj" title="Code">💻</a></td>
    <td align="center"><a href="antoinecully.com"><img src="https://avatars3.githubusercontent.com/u/6448924?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Antoine Cully</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=Aneoshun" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=Aneoshun" title="Code">💻</a></td>
    <td align="center"><a href="https://dctrud.sdf.org"><img src="https://avatars1.githubusercontent.com/u/4522799?v=4?s=100" width="100px;" alt=""/><br /><sub><b>David Trudgian</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=dctrud" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/serlophug"><img src="https://avatars3.githubusercontent.com/u/20574493?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Sergio López Huguet</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=serlophug" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=serlophug" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/jbd"><img src="https://avatars2.githubusercontent.com/u/169483?v=4?s=100" width="100px;" alt=""/><br /><sub><b>jbd</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=jbd" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=jbd" title="Code">💻</a></td>
    <td align="center"><a href="http://alex.hirzel.us/"><img src="https://avatars3.githubusercontent.com/u/324152?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Alex Hirzel</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=alhirzel" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=alhirzel" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="http://tangiblecomputationalbiology.blogspot.com"><img src="https://avatars0.githubusercontent.com/u/207407?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Steffen Möller</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=smoe" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=smoe" title="Code">💻</a></td>
    <td align="center"><a href="www.onerussian.com"><img src="https://avatars3.githubusercontent.com/u/39889?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Yaroslav Halchenko</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=yarikoptic" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=yarikoptic" title="Code">💻</a></td>
    <td align="center"><a href="http://sourceforge.net/u/victorsndvg/profile/"><img src="https://avatars3.githubusercontent.com/u/6474985?v=4?s=100" width="100px;" alt=""/><br /><sub><b>victorsndvg</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=victorsndvg" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=victorsndvg" title="Code">💻</a></td>
    <td align="center"><a href="arfon.org"><img src="https://avatars1.githubusercontent.com/u/4483?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Arfon Smith</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=arfon" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=arfon" title="Code">💻</a></td>
    <td align="center"><a href="https://ransomwareroundup.com"><img src="https://avatars3.githubusercontent.com/u/9367754?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Brie Carranza</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=bbbbbrie" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=bbbbbrie" title="Code">💻</a></td>
    <td align="center"><a href="https://orcid.org/0000-0002-6178-3585"><img src="https://avatars1.githubusercontent.com/u/145659?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Dan Fornika</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=dfornika" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=dfornika" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/RonaldEnsing"><img src="https://avatars2.githubusercontent.com/u/8299064?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Ronald Ensing</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=RonaldEnsing" title="Documentation">📖</a> <a href="https://github.com/singularityhub/sregistry/commits?author=RonaldEnsing" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/vladdoster"><img src="https://avatars.githubusercontent.com/u/10052309?v=4?s=100" width="100px;" alt=""/><br /><sub><b>vladdoster</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=vladdoster" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/pini-gh"><img src="https://avatars.githubusercontent.com/u/1241814?v=4?s=100" width="100px;" alt=""/><br /><sub><b>pini-gh</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=pini-gh" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/0nebody"><img src="https://avatars.githubusercontent.com/u/26727168?v=4?s=100" width="100px;" alt=""/><br /><sub><b>0nebody</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=0nebody" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/dtrudg"><img src="https://avatars.githubusercontent.com/u/4522799?v=4?s=100" width="100px;" alt=""/><br /><sub><b>dtrudg</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=dtrudg" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/craigwindell"><img src="https://avatars.githubusercontent.com/u/44250868?v=4?s=100" width="100px;" alt=""/><br /><sub><b>craigwindell</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=craigwindell" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/hashkeks"><img src="https://avatars.githubusercontent.com/u/34633191?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Cedric</b></sub></a><br /><a href="https://github.com/singularityhub/sregistry/commits?author=hashkeks" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

## What is Singularity Registry

Singularity Registry Server is a server to provide management and storage of 
Singularity images for an institution or user to deploy locally. 
It does not manage building but serves endpoints to obtain and save containers. 

## Images Included

Singularity Registry consists of several Docker images, and they are integrated 
to work together using [docker-compose.yml](docker-compose.yml).

The images are the following:

 - **vanessa/sregistry**: is the main uWSGI application, which serves a Django (python-based) application.
 - **nginx**: pronounced (engine-X) is the webserver. The starter application is configured for HTTP. However, you should follow our [instructions](https://singularityhub.github.io/sregistry/docs/install/server#ssl) to set up HTTPS properly. Note that we build a custom NGINX image that takes advantage of the [nginx-upload-module](https://www.nginx.com/resources/wiki/modules/upload/).
 - **worker**: is the same uWSGI image, but with a running command for queueing jobs and processing them in the background. These jobs run via [django-rq](https://github.com/rq/django-rq) backed by a
 - **redis**: database to organize the jobs themselves.
 - **scheduler** jobs can be scheduled using the scheduler.

For more information about Singularity Registry Server, please reference the
[docs](https://singularityhub.github.io/sregistry). If you have any issues,
please [let me know](https://github.com/singularityhub/sregistry/issues)!

## License

This code is licensed under the MPL 2.0 [LICENSE](LICENSE).
