# FAQs

1. Why ranked from 1-3 initially?
2. why did you patch tools?
   To better evaluate the maximum performance of a tool with its idosyncratic design without altering its fundamental design or code base. Also, I only patched subtle bugs that hinder our evaluations, while the benchmark and design choises made by the developers stay intact. More specifically, I added "User: please regenerate the plan" is because it is already covered in ASB's design, its just its implementation does not really work. That's why I patched it. However, ASB's "plain text response", which fails to ensure models always returning a valid JSON, is its own design choice and certainly works, which I'll not patch or modify.
