Registry.require(["promise","helper","convert","xmlhttprequest"],function(){var n=Registry.log,F=rea.FEATURES,d=Registry.get("promise"),D=Registry.get("helper"),G=Registry.get("convert"),H=Registry.get("xmlhttprequest").run,q=0,p=0,v={ePASTEBIN:1,eCHROMESYNC:2,eGOOGLEDRIVE:3},z=[],C=!1,w=null,J=[{method:"HEAD",url:"https://www.google.com",extract:function(d,e){try{for(var n=e?e.split("\n"):[],g=0;g<n.length;g++){var k=n[g].split(":"),M=k.shift()||"",I=k.join(":")||"";if("date"==M.trim().toLowerCase()&&
I)return new Date(I)}}catch(q){}return null}},{method:"GET",url:"https://json-time.appspot.com/time.json",extract:function(d){try{var e=JSON.parse(d);if(!e.error&&e.datetime)return new Date(e.datetime)}catch(n){}return null}}],u=function(){var h=function(){var k,e=!1,h=null,g=function(a){},l=function(a){h=a.state;n.log("si: sync filesystem state changed to : "+h)},q=function(){var a=d(),f=function(b){n.warn("si: listFiles() error:",b);a.reject()};k.root.getDirectory("/",{create:!0},function(b){var A=
b.createReader(),c=[],d=function(){A.readEntries(function(b){b.length?(c=c.concat(b),d()):a.resolve(c)},f)};d()},f);return a.promise()},p=function(a,f){var b=d(),A=function(f){n.warn("si: writeFileData(",a,") error:",f);b.reject()};k.root.getDirectory("/",{create:!0},function(c){c.getFile(a,{create:!0},function(a){a.createWriter(function(a){a.onwriteend=function(c){a.onwriteend=function(a){b.resolve()};a.onerror=A;c=new Blob([f],{type:"text/plain"});a.write(c)};a.truncate(0)},A)},A)},A);return b.promise()},
t=function(a){var f=d(),b=function(b){n.warn("si: getFileData(",a,") error:",b);f.reject()},c=function(a){var c=new FileReader;c.onloadend=function(){f.resolve(this.result)};c.onerror=b;c.onabort=b;c.readAsText(a)};k.root.getDirectory("/",{create:!0},function(f){f.getFile(a,{},function(a){a.file(function(a){c(a)},b)},b)},b);return f.promise()},r=function(a){var f=d(),b=function(b){n.warn("fileStorage: deleteFile(",a,") error:",b);f.reject()};k.root.getDirectory("/",{create:!0},function(c){c.getFile(a,
{create:!1},function(a){a.remove(f.resolve,b)},b)},b);return f.promise()},m=null,y={},c=function(){return B(function(){var a=d(),f=[];D.each(y,function(a,c){f.push(function(){var f=d();p(c,a).always(function(){f.resolve()});return f.promise()}())});y={};d.when(f).done(function(){a.resolve()});return a.promise()})};return{init:function(){if(!e){try{rea.syncFileSystem.onFileStatusChanged.addListener(g)}catch(f){n.warn("si: error registering file status callback: "+f.message)}if(F.SYNC.GOOGLE_DRIVE.HAS_SERVICE_STATUS)try{rea.syncFileSystem.onServiceStatusChanged.addListener(l)}catch(f){n.warn("si: error registering service status callback: "+
f.message)}e=!0}var a=d();rea.syncFileSystem.supported?rea.syncFileSystem.requestFileSystem(function(f){rea.runtime.lastError?a.resolve(!1):(k=f,a.resolve(!0))}):a.resolve(!1);return a.promise()},list:function(){return q().then(function(a){var f=[],b=[],c=d(),m=/.user.js$/;a.forEach(function(a){-1!=a.search(m)&&b.push(function(){var b=d();t(a).done(function(a){var b;try{b=JSON.parse(a)}catch(c){}b&&f.push({uuid:b.uuid,url:b.url,options:b.options?b.options:{},content:b.content})}).always(function(){b.resolve()});
return b.promise()}())});d.when(b).done(function(){c.resolve(f)});return c.promise()})},add:function(a){y[a.uuid+".user.js"]=JSON.stringify({uuid:a.uuid,url:a.url,options:a.options,content:a.content});m&&window.clearTimeout(m);m=window.setTimeout(c,3E3);return d.Pledge()},write:c,remove:function(a){var f={uuid:a.uuid,url:a.url,options:a.options||{}};f.options.removed=Date.now()+w;y[a.uuid+".user.js"]=JSON.stringify(f);m&&window.clearTimeout(m);m=window.setTimeout(c,3E3);return d.Pledge()},reset:function(){return q().then(function(a){var c=
[],b=d();a.forEach(function(a){c.push(function(){var b=d();r(a).always(function(){b.resolve()});return b.promise()}())});d.when(c).done(function(){b.resolve()});return b.promise()})}}}(),e=function(){var k=!1,e,h=function(c,a){if(q==v.eCHROMESYNC&&"sync"==a)if(null===w)E().done(function(){h(c,a)});else{var f=new RegExp(e+"$");c&&Object.keys(c).forEach(function(b){var d=c[b];n.debug('si: storage key "%s" in namespace "%s" changed. Old value was "%s", new value is "%s".',b,a,d.oldValue,d.newValue);
if(-1!=b.search(f))for(var m=0;m<z.length;m++)if(!r[b]){var e=u(d.newValue,b);if(e)z[m](b,e)}})}},g=function(c,a){var f=d(),b=[];a?l().done(function(d){"url"==c&&(a=a.split("#")[0]);b=D.select(d,function(b){return b.item&&b.item[c]==a});f.resolve(b)}).fail(function(a){f.reject(a)}):f.resolve(b);return f.promise()},l=function(){return B(function(){var c=d(),a=new RegExp(e+"$");rea.storage.sync.get(null,function(f){var b=[];f&&Object.keys(f).forEach(function(c){-1!=c.search(a)&&b.push({key:c,item:u(f[c],
c)})});c.resolve(b)});return c.promise()})},u=function(c,a){var f=null;try{f=JSON.parse(c)}catch(b){}return f&&f.url?f:(n.debug("si: unable to parse extended info of "+a),null)},x=function(c){return c.then(function(a){var c={};a=D.select(a,function(a,b){if(!c[a.key])return c[a.key]=!0});if(1<a.length){var b=d(),e=[],k=a.pop();a.forEach(function(a){e.push(m(a.key))});d.when(e).done(function(){b.resolve(k)});return b.promise()}return d.Pledge(a[0])})},t=null,r={},m=function(c,a){return B(function(){var a=
d();rea.storage.sync.remove(c,function(b){(b=rea.runtime.lastError)?a.reject(b):a.resolve()});return a.promise()})},y=function(c){return B(function(){var a=d();rea.storage.sync.set(r,function(c){(c=rea.runtime.lastError)?a.reject(c):(r={},a.resolve())});return a.promise()})};return{init:function(){var c=!0;if(!k)try{rea.storage.onChanged.addListener(h),k=!0}catch(a){n.warn("si: error registering sync callback: "+a.message),c=!1}2==p?e="@v2":(p=1,e="@us");return d.Pledge(c)},list:function(){var c;
c=null===w?E():d.Pledge();return c.then(function(){return l()}).then(function(a){var c=new RegExp(e+"$"),b=[];a.forEach(function(a){var d=a.key;a=a.item;var m=d.replace(c,""),e=null;(e=r[d]?u(r[d],d):a)&&(1==p||(!e.vmin||p>=e.vmin)&&(!e.vmax||p<=e.vmax))&&b.push({id:m,uuid:e.uuid,url:e.url,options:e.options||{}})});return d.Pledge(b)})},add:function(c){var a=d(),f=2==p?g("uuid",c.uuid):g("url",c.url);x(f).done(function(b){var f;b?(f=b.key,b=b.item):(f=c.uuid+e,b={});b.url=c.url;b.options=c.options||
{};2==p&&(b.uuid=c.uuid);r[f]=JSON.stringify(b);t&&window.clearTimeout(t);t=window.setTimeout(y,3E3);a.resolve()});return a.promise()},remove:function(c){var a=d(),f=2==p?g("uuid",c.uuid):g("url",c.url);x(f).done(function(b){var f;b?(f=b.key,b=b.item):(f=c.uuid+e,b={});b.options=b.options||{};b.options.removed=Date.now()+w;r[f]=JSON.stringify(b);t&&window.clearTimeout(t);t=window.setTimeout(y,3E3);a.resolve()});return a.promise()},reset:function(){return B(function(){var c=d();rea.storage.sync.clear(function(){r=
{};c.resolve()});return c.promise()})}}}(),l=function(){var e,h=null,g=function(){var m=d();e?H({method:"GET",retries:3,url:e},{onload:function(d){4==d.readyState&&(200==d.status?m.resolve(d.responseText):m.reject())},onerror:m.reject}):m.reject({});return m.promise()},l=function(){var e=d();g().done(function(d){p(d).done(function(c){h=G.MD5(d);e.resolve(c)})}).fail(function(d){e.reject(d)});return e.promise()},p=function(e){var h=d(),c=[];try{e=e.replace(/\t/g,"    ");e=e.replace(/\r/g,"\n");e=e.replace(/\n\n+/g,
"\n");for(var a=e.split("\n"),f=0;f<a.length;f++){var b=a[f],g=b.split("|");if(3<g.length)n.log("si: can't handle line: "+b);else{var k=g[g.length-1],l=null,q=null;if(1<g.length)for(var p=g.length-2;0<=p;p--)try{l=JSON.parse(g[p])}catch(r){q=g[p]}c.push({name:q,url:k,options:l||{}})}}}catch(r){n.warn("si: unable to parse data: "+e)}h.resolve(c);return h.promise()},u=function(){var e=d();g().done(function(e){p(e).done(function(c){if(h!=G.MD5(e))for(c=0;c<z.length;c++)z[c]()})}).fail(function(d){e.reject(d)});
return e.promise()},x=null,t=function(e){if(x)if(e)window.clearTimeout(x);else return;n.debug("si: schedule sync for periodical run every 18000000 ms");x=window.setTimeout(function(){x=null;q==v.ePASTEBIN&&u().always(function(){t()})},18E6)},r={init:function(g){e="https://pastebin.com/raw.php?i=%s".replace("%s",g);t(!0);return d.Pledge(!0)},list:function(){return null===w?E().then(function(){return r.list()}):l()}};return r}(),g={};g[v.ePASTEBIN]=l;g[v.eCHROMESYNC]=e;F.SYNC.GOOGLE_DRIVE.SUPPORTED&&
(g[v.eGOOGLEDRIVE]=h);return g}(),K=function(){var h=d(),e=0,l=function(){if(e<J.length){var d=J[e];H({method:d.method,url:d.url},{ondone:function(k){4==k.readyState&&200==k.status?(k=d.extract(k.responseText,k.responseHeaders),null===k?(e++,window.setTimeout(l,1)):h.resolve(k)):(e++,window.setTimeout(l,1))}})}else h.reject(void 0)};l();return h.promise()},E=function(){var h=d();K().done(function(e){w=e.getTime()-Date.now()}).fail(function(){w=0;n.log("si: time offset detection failed!")}).always(h.resolve);
return h.promise()},B=function(h,e){var l=d();void 0===e&&(e=3);var g=function(){if(C)window.setTimeout(g,500);else{C=!0;try{h().always(function(){C=!1}).done(function(){l.resolve.apply(this,arguments)}).fail(function(){0<--e?(n.log("si: some retries left, wait for",6E4,"ms"),window.setTimeout(g,6E4)):(n.warn("si: no retries left, skipping this sync request!"),l.reject("no retries left"))})}catch(d){n.warn(d),C=!1,l.reject(d)}}};g();return l.promise()},L={init:function(h,e,l){z=[];q=h;p=e;return u[q]?
u[q].init(l).done(function(d){}):d.Breach()},getUtc:K,debug:function(d){},addChangeListener:function(d){z.push(d)},isWritable:function(){return q==v.eCHROMESYNC||q==v.eGOOGLEDRIVE},types:v};["list","add","reset","remove"].forEach(function(h){L[h]=function(){return u[q]&&u[q][h]?u[q][h].apply(this,arguments):d.Pledge()}});Registry.register("syncinfo","5362",L)});
