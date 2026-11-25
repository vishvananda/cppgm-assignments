typedef typeof(nullptr) Null;
Null choose(int condition) { return condition ? nullptr : 0; }
