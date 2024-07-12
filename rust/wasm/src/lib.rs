use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn power(n: i32) -> i32 {
  if n==0 {
    return 1;
  } else {
    return 2*power(n-1);
  }
}

#[wasm_bindgen]
pub fn title(name: &str) -> String {
    return format!("Ya.Game {name}");
}