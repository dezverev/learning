// Return the length of whichever string is longer.
fn longer_len(a: &str, b: &str) -> usize {
    if a.len() > b.len() { a.len() } else { b.len() }
}

// Append a single '!' to the string, IN PLACE.
fn add_bang(s: &mut String) {
    s.push('!');
}

fn main() {
    let mut greeting = String::from("hello");
    let other = "hi there"; // a literal is already a &str

    // TODO 1: print the longer length.
    println!("longer length: {}", longer_len(&greeting, other));

    // TODO 2: add a bang to greeting (mutable borrow).
    add_bang(&mut greeting);

    // TODO 3: greeting is STILL usable — it was only ever borrowed, never moved.
    println!("{greeting}");
}
