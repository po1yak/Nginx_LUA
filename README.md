# Description of files
------------
	* Dockerfile - builds image of Nginx server with a lua-nginx-module based on ubuntu:16.04

	* index.lua - test script 

	* nginx.conf - NGINX configuration

# Description 
------------


Latest NGINX server has been build from src files. Public Docker registry has configured 
with autobuild option from linked GitHub repository with Dockerfile . 
Autobuild starts by push event to the master branch. 

Description of deploy process
------------

- push event to the master branch
- GitHub webhook to hub.docker.com
- autobuild image based on Dockerfile from GitHub
