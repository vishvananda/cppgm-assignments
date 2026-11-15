int check(unsigned value) { switch (value) { case -1: return 1; case ~0u: return 2; } return 0; }
