import json,re,sys
HYPE=re.compile(r"\b(no way|oh my god|omg|what|wait|bro|let'?s go|holy|insane|crazy|yo+|wtf|dude|look at|nah|run|go go|bro|crazy|unbelievable|realistic|detail)\b",re.I)
SPOIL=re.compile(r"\b(lucia|mission|kid|child|children|son|baby|died|dies|ending|story|cutscene|prison|cal|boobie|raul|brian)\b",re.I)
TOPIC=re.compile(r"\b(gas|cops?|police|wanted|gator|alligator|crocodile|beach|graphics|physics|car|plane|boat|flamingo|helicopter|chase|crash|ragdoll|npc|realistic|map|vice city|gun|shoot)\b",re.I)
id=sys.argv[1]; d=json.load(open(f'tr-{id}.json'))['content']
W=75000;res=[]
end=max(c['offset'] for c in d)
for s in range(0,end,15000):
    seg=[c for c in d if s<=c['offset']<s+W]
    t=' '.join(c['text'] for c in seg)
    h=len(HYPE.findall(t)); sp=len(SPOIL.findall(t)); tp=len(TOPIC.findall(t))
    res.append((h+0.5*tp-3*sp,s,h,tp,sp,t))
res.sort(reverse=True)
used=[]
k=0
for r in res:
    if any(abs(r[1]-u)<300000 for u in used): continue
    used.append(r[1]);k+=1
    print(f"## {r[1]//60000}:{r[1]//1000%60:02d} score={r[0]} hype={r[2]} topic={r[3]} spoil={r[4]}\n{r[5][:600]}\n")
    if k>=8:break
