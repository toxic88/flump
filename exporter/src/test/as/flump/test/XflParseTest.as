//
// Flump - Copyright 2012 Three Rings Design

package flump.test {

import flump.executor.Finisher;
import flump.executor.Future;
import flump.export.XflLoader;
import flump.xfl.XflLibrary;

public class XflParseTest
{
    public function XflParseTest (runner :TestRunner) {
        runner.runAsync("Parse Bella", makeParseTest("bella", function (lib :XflLibrary) :void {
            assert(lib.getErrors().length != 0, "Expected warnings in bella");
        }));
        runner.runAsync("Parse Squaredance", makeParseTest("squaredance", function (lib :XflLibrary) :void {
            assert(lib.getErrors().length == 0, "Expected no errors in squaredance");
            new PublishTest(runner, lib);
        }));
    }

    protected function makeParseTest (name :String, postParse :Function) :Function {
        return function (finisher :Finisher) :void {
            const load :Future = new XflLoader().load(name, TestRunner.resources.resolvePath(name));
            load.succeeded.add(function (lib :XflLibrary) :void {
                finisher.succeedAfter(function (..._) :void {
                    assert(lib.valid, "Lib should be valid");
                    postParse(lib);
                });
            });
            load.failed.add(finisher.fail);
         }
    }
}
}