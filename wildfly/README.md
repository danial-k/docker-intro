# Deploying Java WARs to WildFly application server
This examples assumes completion of the [Java Thorntail Maven](../master/thorntail/README.md) and [Java JSP Jetty Maven](../master/maven/README.md) examples.

Create a new WildFly container and enable the management console:
```shell
docker run \
-it \
--name wildfly \
--hostname wildfly \
-p 3950:8080 \
-p 3951:9990 \
jboss/wildfly \
//opt/jboss/wildfly/bin/standalone.sh \
-bmanagement 0.0.0.0 \
-b 0.0.0.0
```

Create a new administrative user for the management console:
```shell
docker exec wildfly //opt/jboss/wildfly/bin/add-user.sh -u admin -p admin
```

The management console should then be visible at http://127.0.0.1:3951.

Start a deployment in the management console and upload the WAR file from the ```target``` directory of the [Java Thorntail Maven](../master/thorntail/README.md) and [Java JSP Jetty Maven](../master/maven/README.md) examples.

The application endpoints should be visible at http://127.0.0.1:3950/restful-endpoint/rest/hello and http://127.0.0.1:3950/app/.
In the management console under ```Runtime``` > ```Server``` > ```JAX-RS``` The REST endpoints should also be listed. 

## Monitoring requests
Once deployed, under ```Runtime``` > ```Server``` > ```Web``` > ```Server``` > ```default-server``` > ```default```, enable statistics.
Create a new CentOS container and execute multiple cURL requests against the WildFly application server:
```shell
docker run -it centos
```
In this container run the following and monitor the WildFly webserver statistics:
```shell
curl -s "http://<wildfly-docker-ip>:8080/app/?[1-1000]"
curl -s "http://<wildfly-docker-ip>:8080/resfult-endpoint/rest/hello/?[1-1000]"
```
