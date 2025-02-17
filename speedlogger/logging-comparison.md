## Comparison of Logging Approaches

Let's compare these two logging approaches:

1. `echo "$(date +"%Y-%m-%d %H:%M:%S") - $line" >> "$LOG_FILE"`
2. `echo "$(date +"%Y-%m-%d %H:%M:%S") - $line" | tee -a "$LOG_FILE"`

### Functionality

Both commands achieve logging with timestamps, but there are key differences:

1. First approach (`>>`):
   - Redirects output only to the log file
   - Silent operation - no output to terminal
   - Slightly more efficient as it only writes once

2. Second approach (`tee -a`):
   - Writes to both the log file AND displays on standard output (terminal)
   - Useful for seeing the log messages in real-time while still logging them
   - The `-a` flag ensures the log file is appended to rather than overwritten

### When to Use Each

Use the first approach (`>>`) when:
- You only need to log without seeing the output
- You want slightly better performance
- You want silent operation

Use the second approach (`tee -a`) when:
- You need to monitor the logs in real-time while they're being written
- You want to both log and see the output without writing two separate commands
- You're debugging and want visual confirmation of what's being logged

### Performance Consideration

The `tee` approach has a tiny performance overhead since it writes to both the file and stdout, but
this is negligible in most use cases. The benefit of seeing the output in real-time often
outweighs this minor performance impact.

### Example Use Case

```bash
# Silent logging (first approach)
for line in "${lines[@]}"; do
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $line" >> "$LOG_FILE"
done

# Visible logging (second approach)
for line in "${lines[@]}"; do
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $line" | tee -a "$LOG_FILE"
done
```