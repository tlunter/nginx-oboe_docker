# nginx-oboe\_docker

How to test

```
docker run -v /Users/toddlunter/Misc/nginx-oboe/test-config:/opt/nginx/conf.d nginx-oboe
```

This'll run using the test config.  Should this not die (if linked), or die only with this, you're probably all set!

> [Tue Jul  7 01:26:39 2015] UDP reporter initialization failed - No UDP support for tracelyzer:7831 [reporter/udp.c:84] [Oboe-lib-warn p#5]
> nginx: ../nginx\_oboe/ngx\_http\_oboe\_filter\_module.c:262: ngx\_http\_oboe\_filter\_init: Assertion \`plugin\_data.reporter.send' failed.
