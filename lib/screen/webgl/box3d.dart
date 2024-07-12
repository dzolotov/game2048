import 'dart:js_interop';
import 'dart:typed_data' as typed_data;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:web/web.dart';

class Box3D extends HookWidget {
  static const size = 64.0;

  const Box3D({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      ui_web.platformViewRegistry.registerViewFactory('canvas3d', (_) {
        final canvas = HTMLCanvasElement();
        canvas.style.width = '${size}px';
        canvas.style.height = '${size}px';
        canvas.setAttribute('id', 'canvas3d');
        return canvas;
      });
      //wait for DOM update (flt-platform-view)
      Future.delayed(const Duration(milliseconds: 500), () {
        final canvas = document.querySelector('#canvas3d') as HTMLCanvasElement;
        WebGLRenderingContext gl =
            canvas.getContext3d() as WebGLRenderingContext;
        final vertices = typed_data.Float32List.fromList([
          -1,
          0,
          0.0,
          0,
          -1,
          0.0,
          1,
          0,
          0.0,
        ]);
        final indices = typed_data.Uint16List.fromList([0, 1, 2]);
        var vertCode = '''
        attribute vec3 coordinates;
        void main(void) {
          gl_Position = vec4(coordinates, 1.0);
        }
        ''';
        var fragCode = '''
        void main(void) {
          gl_FragColor = vec4(1, 1, 0.5, 1);
        }
        ''';
        //create vertex buffer
        final vertexBuffer = gl.createBuffer();
        gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
        gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER, vertices.toJS,
            WebGL2RenderingContext.STATIC_DRAW);
        gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, null);
        //create indices buffer
        final indexBuffer = gl.createBuffer();
        gl.bindBuffer(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.bufferData(WebGL2RenderingContext.ELEMENT_ARRAY_BUFFER, indices.toJS,
            WebGL2RenderingContext.STATIC_DRAW);
        gl.bindBuffer(WebGL2RenderingContext.ELEMENT_ARRAY_BUFFER, null);

        //create vertex shader
        final vertShader = gl.createShader(WebGLRenderingContext.VERTEX_SHADER);
        gl.shaderSource(vertShader!, vertCode);
        gl.compileShader(vertShader);
        //create fragment shader
        final fragShader =
            gl.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
        gl.shaderSource(fragShader!, fragCode);
        gl.compileShader(fragShader);
        //create shader program
        final shaderProgram = gl.createProgram();
        gl.attachShader(shaderProgram!, vertShader);
        gl.attachShader(shaderProgram, fragShader);
        gl.linkProgram(shaderProgram);
        gl.useProgram(shaderProgram);
        //bind buffers
        gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
        gl.bindBuffer(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
        final coords = gl.getAttribLocation(shaderProgram, 'coordinates');
        gl.vertexAttribPointer(coords, vertices.length ~/ 3,
            WebGLRenderingContext.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(coords);
        //draw
        gl.clearColor(0.2, 0.2, 0.2, 0.8);
        gl.enable(WebGLRenderingContext.DEPTH_TEST);
        gl.clear(WebGLRenderingContext.COLOR_BUFFER_BIT);
        gl.viewport(0, 0, 300, 300);
        gl.drawElements(
          WebGL2RenderingContext.TRIANGLES,
          indices.length,
          WebGLRenderingContext.UNSIGNED_SHORT,
          0,
        );
      });
    }, const []);
    return const SizedBox(
      width: size,
      height: size,
      child: HtmlElementView(
        viewType: 'canvas3d',
      ),
    );
  }
}
