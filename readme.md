# OSM Routing
An Erlang geo-routing system based on OpenStreetMap data which provides an HTTP-API.

## Authors
- [Mirko Kiefer](https://github.com/mirkok)
- [Haykuhi Jaghinyan](mailto:haikuhi290489@aol.com)
- [Johannes Auer](https://github.com/johannesauer)

## Installation
Get the current source from https://github.com/livelycode/routing.
### Erlang
#### Download
1. Download Erlang/OTP R14B03 at http://www.erlang.org/download.html.
2. Unpack the download.
3. Now cd into the base dir.  

####Build
	$ ./configure
	$ make  
####Install  
	$ make install

### Erlsom
#### Download
	$ git clone https://github.com/willemdj/erlsom.git
#### Build
	$ cd erlsom
	$ make
#### Install
Move folder to erlang path.

### MochiWeb
#### Download
	$ git clone https://github.com/mochi/mochiweb.git
#### Build
	$ cd mochiweb
	$ make
#### Install
Move folder to erlang path.

### OSM Routing
#### Build
	$ cd routing/ebin
	$ erl -compile ../src/*.erl

## Usage
Make sure you are in the ebin directory.
### Start Erlang Interpreter
	$ erl

### Create Database
	$ routing:load_osm_data("/path/to/your/osm/file.osm").

### Start Server
	$ routing:start().

### Stop Server
	$ routing:stop().

## API Documentation

[API Documentation](https://github.com/livelycode/routing/blob/master/api.md)