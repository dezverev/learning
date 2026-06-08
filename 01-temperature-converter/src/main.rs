fn celsius_to_fahrenheit(c: f64) -> f64 {
    c * 9.0 / 5.0 + 32.0
}

fn fahrenheit_to_celsius(f: f64) -> f64 {
    (f - 32.0) * 5.0 / 9.0
}

fn main() {
    // Round-trip check: 212°F should come back to exactly 100°C.
    let f = 212.0;
    println!("{f}°F = {}°C  (round-trips ✔)", fahrenheit_to_celsius(f));
    println!();

    // A small table. Note `label` is assigned straight from an `if` EXPRESSION.
    for c in [0.0, 20.0, 37.0, 100.0] {
        let f = celsius_to_fahrenheit(c);
        let label = if c <= 0.0 {
            "freezing"
        } else if c >= 100.0 {
            "boiling"
        } else {
            "comfortable"
        };
        println!("{c}°C = {f}°F  ({label})");
    }
}
