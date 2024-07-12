import 'dart:js_interop';

extension type Response(JSObject _) implements JSObject {
  external bool ok;
  external int status;
  external JSAny body; //ReadableStream
}

extension type WebasmModule(JSObject _) implements JSObject {
  external WebasmInstance get instance;
}

extension type WebasmInstance(JSObject _) implements JSObject {
  external WebasmExports get exports;
}

extension type WebasmExports(JSObject _) implements JSObject {
  external int factorial(int n);

  external int power(int n);
}

@JS("WebAssembly.instantiateStreaming")
external JSPromise<WebasmModule> instantiateStreaming(
    JSPromise<Response> data, JSObject init);

@JS("fetch")
external JSPromise<Response> fetch(String url);
