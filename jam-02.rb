beat = 0
bar = 0

define :updateTime do
  beat = beat + 1
  if beat >= 32
    beat = 0
    bar = bar + 1
    if bar >= 4
      bar = 0
    end
  end
end

define :bpmToBeatTime do |bpm|
  (60000.0/bpm)/1000.0
end

sleepTime = bpmToBeatTime(120 * 4)

live_loop :main_loop do
  # run instruments
  kicks
  snares
  hats
  bass
  open_hat
  toms

  # update time
  sleep sleepTime
  updateTime
end

###########################################################
# BASS
###########################################################
define :bass_note do |noteNum, cutoff|
  use_synth :beep
  # use_synth :subpulse
  play noteNum, attack: 0.01, sustain: 0.01, release: 0.066, cutoff:cutoff
end

bassNote = choose(chord(:A2, :minor))
define :bass do
  if beat % 4 == 0
    bassNote = choose(chord(:A2, :minor)) # choose([52, 54, 55])
  end
  # if beat % 4 >= 1
  bass_note bassNote - 12, 30 + 2 * beat
  # end
end

###########################################################
# SYNTH
###########################################################
define :synthy do |baseNote|
  use_synth :pulse
  with_fx :reverb do |r|
    control r, mix: 0.5
    play baseNote, attack: 0.01, sustain: 0.1, release: 0.1, amp: 0.2, pan: 0.1, cutoff: rrand(60, 110)
  end
end

define :synthh do
  if beat != 0 && (beat % 2 == 0 || beat == 15)
    newNote = choose(chord(:A4, :minor)) # choose([52, 54, 55])
    synthy newNote
  end
end

###########################################################
# KICK
###########################################################
define :kicks44 do
  if beat % 4 == 0
    sample :bd_808, rate: 0.8, amp: 1.7
  end
  if beat == 1 && one_in(3)
    sample :bd_808, rate: 1, amp: 1.7
  end
end

define :kicks do
  if beat % 3 == 0 && beat < 9 # bar % 2 == 0
    with_fx :reverb do |r|
      control r, mix: 0.05
      sample :bd_haus, rate: 1, amp: 1.1
    end
    sample :bd_808, rate: 1, amp: 1.1
  end
  if (beat + 2) % 3 == 0 && beat > 12 && beat < 24 # bar % 2 == 0
    with_fx :reverb do |r|
      control r, mix: 0.05
      sample :bd_haus, rate: 1, amp: 1.1
    end
    sample :bd_808, rate: 1, amp: 1.1
  end
end

###########################################################
# SNARE
###########################################################
define :snares do
  if beat % 16 == 8 || beat == 9 || beat == 10
    with_fx :reverb do |r|
      control r, mix: 0.1
      sample :elec_mid_snare, amp: 0.7
    end
    with_fx :reverb do |r|
      control r, mix: 0.4
      sample :elec_snare, amp: 0.4
    end
  end
end

###########################################################
# OPEN HAT
###########################################################
define :open_hat do
  if beat % 8 == 4 # && beat % 2 == 0
    with_fx :reverb do |r|
      control r, mix: 0.4
      sample :elec_triangle, pan: 0.4, amp: 0.01
    end
  end
end

###########################################################
# HATS
###########################################################
define :hats do
  if beat % 4 == 2 || beat % 4 == 3
    if one_in(2)
      sample :elec_plip, amp: 0.5, pan: -0.5, rate: rrand(0.8, 1.0)
    else
      sample :elec_plip, amp: 0.5, pan: 0.6, rate: rrand(0.7, 1.0)
    end
  end
end

###########################################################
# CRUSH EFX
###########################################################
define :toms do
  if beat <= 3
    with_fx :reverb do |r|
      control r, mix: beat * 0.1
      sample :elec_flip, amp: rrand(0.5, 0.7)
    end
  end
  if (beat + 3) % 3 == 0 && beat > 12 && beat < 24
    with_fx :reverb do |r|
      control r, mix: beat % 4 * 0.1
      sample :elec_flip, amp: rrand(0.9, 1.1)
    end
  end

  if beat == 15 && bar % 2 == 0
    with_fx :reverb do |r|
      control r, mix: 0.4
      sample :elec_fuzz_tom, amp: rrand(0.6, 0.7)
    end
  end

  if beat % 32 >= 29 # && bar % 2 == 1
    with_fx :reverb do |r|
      control r, mix: 0.2
      sample :elec_hollow_kick, amp: rrand(1.2, 1.5)
      sample :elec_plip, amp: rrand(1.5, 1.5)
    end
  end

end
