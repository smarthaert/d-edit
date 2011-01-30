for %%1 in (????) do (
  IF NOT EXIST %%1\check.exe ( copy check.exe %%1 /-y )
)


