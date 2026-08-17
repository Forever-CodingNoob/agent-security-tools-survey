import sys, glob, json
from datetime import datetime
from inspect_ai.log import read_eval_log

def parse(t):
    return datetime.fromisoformat(t.replace("Z", "+00:00"))

logdir = sys.argv[1]
files = sorted(glob.glob(f"{logdir}/*.eval"))
if not files:
    print(f"NO_LOG in {logdir}")
    sys.exit(0)
log = read_eval_log(files[-1])
print(f"file: {files[-1]}")
print(f"status: {log.status}")
n = len(log.samples) if log.samples else 0
st = log.stats
dur = (parse(st.completed_at) - parse(st.started_at)).total_seconds()
usage = {k: {"in": v.input_tokens, "out": v.output_tokens, "total": v.total_tokens} for k, v in (st.model_usage or {}).items()}
metrics = {}
if log.results:
    for sc in log.results.scores:
        for mname, m in sc.metrics.items():
            metrics[mname] = round(m.value, 4)
print(f"samples: {n}")
print(f"wallclock_s: {dur:.0f}  ({dur/max(n,1):.1f}s/sample)")
print(f"headline: avg_score={metrics.get('avg_score')} avg_full_score={metrics.get('avg_full_score')} "
      f"avg_refusals={metrics.get('avg_refusals')} avg_score_non_refusals={metrics.get('avg_score_non_refusals')}")
print(f"tokens: {json.dumps(usage)}")
# category breakdown
cats = {k: v for k, v in metrics.items() if k.endswith("_avg_scores") or k.endswith("_avg_refusals")}
if cats:
    print(f"categories: {json.dumps(cats)}")
