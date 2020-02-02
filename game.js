
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', 'map', true, true);
Module['FS_createPath']('/', 'sfx', true, true);
Module['FS_createPath']('/', 'lib', true, true);
Module['FS_createPath']('/lib', 'pink', true, true);
Module['FS_createPath']('/lib/pink', 'examples', true, true);
Module['FS_createPath']('/lib/pink/examples', 'love2d', true, true);
Module['FS_createPath']('/lib/pink', 'pink', true, true);
Module['FS_createPath']('/lib/pink', 'test', true, true);
Module['FS_createPath']('/lib/pink/test', 'runtime', true, true);
Module['FS_createPath']('/lib/pink/test', 'parser', true, true);
Module['FS_createPath']('/lib', 'sti', true, true);
Module['FS_createPath']('/lib/sti', 'plugins', true, true);
Module['FS_createPath']('/lib', 'hump', true, true);
Module['FS_createPath']('/', 'level', true, true);
Module['FS_createPath']('/', 'img', true, true);
Module['FS_createPath']('/', 'ink', true, true);
Module['FS_createPath']('/', 'music', true, true);
Module['FS_createPath']('/', 'char', true, true);
Module['FS_createPath']('/', 'font', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 101, "filename": "/story.lua"}, {"audio": 0, "start": 101, "crunched": 0, "end": 1400, "filename": "/dbg.lua"}, {"audio": 0, "start": 1400, "crunched": 0, "end": 2192, "filename": "/game.lua"}, {"audio": 0, "start": 2192, "crunched": 0, "end": 13770, "filename": "/level.lua"}, {"audio": 0, "start": 13770, "crunched": 0, "end": 14987, "filename": "/resources.lua"}, {"audio": 0, "start": 14987, "crunched": 0, "end": 15318, "filename": "/main.lua"}, {"audio": 0, "start": 15318, "crunched": 0, "end": 15924, "filename": "/conf.lua"}, {"audio": 0, "start": 15924, "crunched": 0, "end": 18246, "filename": "/textboxes.lua"}, {"audio": 0, "start": 18246, "crunched": 0, "end": 18679, "filename": "/maputils.lua"}, {"audio": 0, "start": 18679, "crunched": 0, "end": 19724, "filename": "/sfx.lua"}, {"audio": 0, "start": 19724, "crunched": 0, "end": 25446, "filename": "/map/tutorial03.lua"}, {"audio": 0, "start": 25446, "crunched": 0, "end": 31213, "filename": "/map/last.lua"}, {"audio": 0, "start": 31213, "crunched": 0, "end": 40417, "filename": "/map/demo.lua"}, {"audio": 0, "start": 40417, "crunched": 0, "end": 40519, "filename": "/map/README.md"}, {"audio": 0, "start": 40519, "crunched": 0, "end": 46800, "filename": "/map/intro.lua"}, {"audio": 0, "start": 46800, "crunched": 0, "end": 51671, "filename": "/map/tutorial01.lua"}, {"audio": 0, "start": 51671, "crunched": 0, "end": 57490, "filename": "/map/tutorial04.lua"}, {"audio": 0, "start": 57490, "crunched": 0, "end": 72974, "filename": "/map/camdemo.lua"}, {"audio": 0, "start": 72974, "crunched": 0, "end": 79057, "filename": "/map/tutorial02.lua"}, {"audio": 0, "start": 79057, "crunched": 0, "end": 87361, "filename": "/map/demo2.lua"}, {"audio": 1, "start": 87361, "crunched": 0, "end": 354837, "filename": "/sfx/106115__j1987__forestwalk.wav"}, {"audio": 1, "start": 354837, "crunched": 0, "end": 601397, "filename": "/sfx/136887__animationisaac__box-of-stuff-falls-old1.wav"}, {"audio": 1, "start": 601397, "crunched": 0, "end": 1029997, "filename": "/sfx/171642__fins__scale-a6.wav"}, {"audio": 1, "start": 1029997, "crunched": 0, "end": 1105185, "filename": "/sfx/235521__ceberation__landing-on-ground-old2.wav"}, {"audio": 1, "start": 1105185, "crunched": 0, "end": 1172529, "filename": "/sfx/151584__d-w__door-handle-jiggle-05-old1.wav"}, {"audio": 1, "start": 1172529, "crunched": 0, "end": 1287569, "filename": "/sfx/160215__qubodup__unlocking-door-lock-old1.wav"}, {"audio": 1, "start": 1287569, "crunched": 0, "end": 1329839, "filename": "/sfx/151584__d-w__door-handle-jiggle-05.wav"}, {"audio": 1, "start": 1329839, "crunched": 0, "end": 1621795, "filename": "/sfx/106115__j1987__forestwalk-old1.wav"}, {"audio": 1, "start": 1621795, "crunched": 0, "end": 1686685, "filename": "/sfx/76960__michel88__deathh.wav"}, {"audio": 1, "start": 1686685, "crunched": 0, "end": 1801725, "filename": "/sfx/160215__qubodup__unlocking-door-lock.wav"}, {"audio": 1, "start": 1801725, "crunched": 0, "end": 1980009, "filename": "/sfx/136887__animationisaac__box-of-stuff-falls.wav"}, {"audio": 1, "start": 1980009, "crunched": 0, "end": 2259925, "filename": "/sfx/235521__ceberation__landing-on-ground-old1.wav"}, {"audio": 1, "start": 2259925, "crunched": 0, "end": 2694669, "filename": "/sfx/171644__fins__scale-g6.wav"}, {"audio": 1, "start": 2694669, "crunched": 0, "end": 2769857, "filename": "/sfx/235521__ceberation__landing-on-ground.wav"}, {"audio": 0, "start": 2769857, "crunched": 0, "end": 2771745, "filename": "/lib/util.lua"}, {"audio": 0, "start": 2771745, "crunched": 0, "end": 2793066, "filename": "/lib/bump.lua"}, {"audio": 0, "start": 2793066, "crunched": 0, "end": 2794735, "filename": "/lib/require.lua"}, {"audio": 0, "start": 2794735, "crunched": 0, "end": 2798856, "filename": "/lib/pink/README.md"}, {"audio": 0, "start": 2798856, "crunched": 0, "end": 2798863, "filename": "/lib/pink/.gitignore"}, {"audio": 0, "start": 2798863, "crunched": 0, "end": 2799132, "filename": "/lib/pink/.travis.yml"}, {"audio": 0, "start": 2799132, "crunched": 0, "end": 2799175, "filename": "/lib/pink/.git"}, {"audio": 0, "start": 2799175, "crunched": 0, "end": 2800246, "filename": "/lib/pink/LICENSE"}, {"audio": 0, "start": 2800246, "crunched": 0, "end": 2800842, "filename": "/lib/pink/examples/game.lua"}, {"audio": 0, "start": 2800842, "crunched": 0, "end": 2801442, "filename": "/lib/pink/examples/game.ink"}, {"audio": 0, "start": 2801442, "crunched": 0, "end": 2802545, "filename": "/lib/pink/examples/love2d/main.lua"}, {"audio": 0, "start": 2802545, "crunched": 0, "end": 2804675, "filename": "/lib/pink/pink/parser.lua"}, {"audio": 0, "start": 2804675, "crunched": 0, "end": 2807267, "filename": "/lib/pink/pink/pink.lua"}, {"audio": 0, "start": 2807267, "crunched": 0, "end": 2811285, "filename": "/lib/pink/pink/runtime.lua"}, {"audio": 0, "start": 2811285, "crunched": 0, "end": 2910775, "filename": "/lib/pink/test/luaunit.lua"}, {"audio": 0, "start": 2910775, "crunched": 0, "end": 2914784, "filename": "/lib/pink/test/test.lua"}, {"audio": 0, "start": 2914784, "crunched": 0, "end": 2915087, "filename": "/lib/pink/test/runtime/tags.ink"}, {"audio": 0, "start": 2915087, "crunched": 0, "end": 2915649, "filename": "/lib/pink/test/runtime/branching.ink"}, {"audio": 0, "start": 2915649, "crunched": 0, "end": 2915661, "filename": "/lib/pink/test/runtime/hello.ink"}, {"audio": 0, "start": 2915661, "crunched": 0, "end": 2915692, "filename": "/lib/pink/test/runtime/include.ink"}, {"audio": 0, "start": 2915692, "crunched": 0, "end": 2917671, "filename": "/lib/pink/test/parser/gather.lua"}, {"audio": 0, "start": 2917671, "crunched": 0, "end": 2918223, "filename": "/lib/pink/test/parser/nested2.lua"}, {"audio": 0, "start": 2918223, "crunched": 0, "end": 2918920, "filename": "/lib/pink/test/parser/glue.lua"}, {"audio": 0, "start": 2918920, "crunched": 0, "end": 2919502, "filename": "/lib/pink/test/parser/knot.lua"}, {"audio": 0, "start": 2919502, "crunched": 0, "end": 2920183, "filename": "/lib/pink/test/parser/basic.lua"}, {"audio": 0, "start": 2920183, "crunched": 0, "end": 2920455, "filename": "/lib/pink/test/parser/include.lua"}, {"audio": 0, "start": 2920455, "crunched": 0, "end": 2921149, "filename": "/lib/pink/test/parser/tags.lua"}, {"audio": 0, "start": 2921149, "crunched": 0, "end": 2921515, "filename": "/lib/pink/test/parser/nested.lua"}, {"audio": 0, "start": 2921515, "crunched": 0, "end": 2922986, "filename": "/lib/pink/test/parser/branching.lua"}, {"audio": 0, "start": 2922986, "crunched": 0, "end": 2923706, "filename": "/lib/pink/test/parser/comments.lua"}, {"audio": 0, "start": 2923706, "crunched": 0, "end": 2924421, "filename": "/lib/pink/test/parser/choices.lua"}, {"audio": 0, "start": 2924421, "crunched": 0, "end": 2925723, "filename": "/lib/sti/LICENSE.md"}, {"audio": 0, "start": 2925723, "crunched": 0, "end": 2927045, "filename": "/lib/sti/init.lua"}, {"audio": 0, "start": 2927045, "crunched": 0, "end": 2964394, "filename": "/lib/sti/map.lua"}, {"audio": 0, "start": 2964394, "crunched": 0, "end": 2966895, "filename": "/lib/sti/README.md"}, {"audio": 0, "start": 2966895, "crunched": 0, "end": 2977417, "filename": "/lib/sti/CHANGELOG.md"}, {"audio": 0, "start": 2977417, "crunched": 0, "end": 2986560, "filename": "/lib/sti/plugins/box2d.lua"}, {"audio": 0, "start": 2986560, "crunched": 0, "end": 2990214, "filename": "/lib/sti/plugins/bump.lua"}, {"audio": 0, "start": 2990214, "crunched": 0, "end": 2995533, "filename": "/lib/hump/vector.lua"}, {"audio": 0, "start": 2995533, "crunched": 0, "end": 2998557, "filename": "/lib/hump/class.lua"}, {"audio": 0, "start": 2998557, "crunched": 0, "end": 3000776, "filename": "/lib/hump/README.md"}, {"audio": 0, "start": 3000776, "crunched": 0, "end": 3003555, "filename": "/lib/hump/signal.lua"}, {"audio": 0, "start": 3003555, "crunched": 0, "end": 3008900, "filename": "/lib/hump/camera.lua"}, {"audio": 0, "start": 3008900, "crunched": 0, "end": 3012460, "filename": "/lib/hump/vector-light.lua"}, {"audio": 0, "start": 3012460, "crunched": 0, "end": 3018815, "filename": "/lib/hump/timer.lua"}, {"audio": 0, "start": 3018815, "crunched": 0, "end": 3022349, "filename": "/lib/hump/gamestate.lua"}, {"audio": 0, "start": 3022349, "crunched": 0, "end": 3022515, "filename": "/level/01_intro.lua"}, {"audio": 0, "start": 3022515, "crunched": 0, "end": 3022641, "filename": "/level/01_test.lua"}, {"audio": 0, "start": 3022641, "crunched": 0, "end": 3022797, "filename": "/level/tut4.lua"}, {"audio": 0, "start": 3022797, "crunched": 0, "end": 3022903, "filename": "/level/tut3.lua"}, {"audio": 0, "start": 3022903, "crunched": 0, "end": 3023462, "filename": "/level/03-test.lua"}, {"audio": 0, "start": 3023462, "crunched": 0, "end": 3023758, "filename": "/level/99_last.lua"}, {"audio": 0, "start": 3023758, "crunched": 0, "end": 3024605, "filename": "/level/02_test.lua"}, {"audio": 0, "start": 3024605, "crunched": 0, "end": 3024786, "filename": "/level/camdemo.lua"}, {"audio": 0, "start": 3024786, "crunched": 0, "end": 3025732, "filename": "/level/demo2.lua"}, {"audio": 0, "start": 3025732, "crunched": 0, "end": 3027241, "filename": "/img/flappyflap.png"}, {"audio": 0, "start": 3027241, "crunched": 0, "end": 3028552, "filename": "/img/shaman.png"}, {"audio": 0, "start": 3028552, "crunched": 0, "end": 3033010, "filename": "/img/green.png"}, {"audio": 0, "start": 3033010, "crunched": 0, "end": 3033980, "filename": "/img/snake.png"}, {"audio": 0, "start": 3033980, "crunched": 0, "end": 3034563, "filename": "/ink/story.ink"}, {"audio": 1, "start": 3034563, "crunched": 0, "end": 9169798, "filename": "/music/03 - Solxis - Rainforest.mp3"}, {"audio": 0, "start": 9169798, "crunched": 0, "end": 9171547, "filename": "/char/flappyflap.lua"}, {"audio": 0, "start": 9171547, "crunched": 0, "end": 9172035, "filename": "/char/snake.lua"}, {"audio": 0, "start": 9172035, "crunched": 0, "end": 9174515, "filename": "/char/character.lua"}, {"audio": 0, "start": 9174515, "crunched": 0, "end": 9175358, "filename": "/char/shaman.lua"}, {"audio": 0, "start": 9175358, "crunched": 0, "end": 9216882, "filename": "/font/SerreriaSobria.otf"}], "remote_package_size": 9216882, "package_uuid": "ba99b157-943d-4b44-8db2-7572e607d345"});

})();
