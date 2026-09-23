set -l color00 '#080A0D'
set -l color01 '#626A73'
set -l color02 '#55FF88'
set -l color03 '#FFD700'
set -l color04 '#00B8FF'
set -l color05 '#FF3CAC'
set -l color06 '#00D9FF'
set -l color07 '#E6E6E6'
set -l color08 '#626A73'
set -l color09 '#FF4A59'
set -l color0A '#7AFFA7'
set -l color0B '#FFE766'
set -l color0C '#4DCAFF'
set -l color0D '#FF75C8'
set -l color0E '#66E7FF'

set -l FZF_NON_COLOR_OPTS
for arg in (echo $FZF_DEFAULT_OPTS | tr ' ' '\n')
    if not string match -q -- '--color*' $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS --color=bg+:$color00,bg:$color00,spinner:$color0E,hl:$color0D --color=fg:$color07,header:$color0D,info:$color0A,pointer:$color0E --color=marker:$color0E,fg+:$color06,prompt:$color0A,hl+:$color0D"
