# Deploying Java WARs to WildFly application server
This examples assumes completion of the [Java Thorntail Maven](../master/thorntail/README.md) and [Java JSP Jetty Maven](../master/maven/README.md) examples.  Here, we take the packaged JARs from those projects and deploy to the WildFly JavaEE-compliant application server.

Create a new WildFly container and enable the management console:
```shell
docker run \
--name wildfly \
--hostname wildfly \
-p 3020:8080 \
-p 3021:9990 \
jboss/wildfly \
//opt/jboss/wildfly/bin/standalone.sh \
-bmanagement 0.0.0.0 \
-b 0.0.0.0
```

Create a new administrative user for the management console:
```shell
docker exec wildfly //opt/jboss/wildfly/bin/add-user.sh -u admin -p admin
```

The management console should then be visible at http://127.0.0.1:3021.

Start a deployment in the management console and upload ```.war``` from the ```target``` directory of the [Java Thorntail Maven](../master/thorntail/README.md) example and ```app.war``` from the [Java JSP Jetty Maven](../master/maven/README.md) example.

The application endpoints should be visible at http://127.0.0.1:3020/restful-endpoint/rest/hello and http://127.0.0.1:3020/app/.
In the management console under ```Runtime``` > ```Server``` > ```JAX-RS``` The REST endpoints should also be listed. 

## Monitoring requests
Once deployed, under ```Runtime``` > ```Server``` > ```Web``` > ```Server``` > ```default-server``` > ```default```, enable statistics.  To make 1000 requests to the endpoints run the following and monitor the WildFly webserver statistics:
```shell
curl "http://127.0.0.1:3020/restful-endpoint/rest/hello/?[1-1000]"
curl "http://127.0.0.1:3020/app/?[1-1000]"
```
