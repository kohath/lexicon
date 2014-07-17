# encoding: utf-8

module LociHelper
  def greek_numeral(int)
    thousands = ['', '͵α', '͵β', '͵γ', '͵δ', '͵ε', '͵στ', '͵ζ', '͵η', '͵θ'][int / 1000 % 10]
    hundreds = ['', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω', 'ϡ'][int / 100 % 10]
    tens = ['', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ϟ'][int / 10 % 10]
    ones = ['', 'α', 'β', 'γ', 'δ', 'ε', 'στ', 'ζ', 'η', 'θ'][int % 10]
    "#{thousands}#{hundreds}#{tens}#{ones}ʹ"
  end
  
  def sense_select(senses)
  	new_senses = {}
  
    groups = senses.collect do |sense|
      dict = (sense.lexeme.dictionaries.first.try(:title) || "(No dictionary)")
      paradigm = sense.subentry.paradigm
      part = ("(" + sense.subentry.part_of_speech + ")" if sense.subentry.part_of_speech)
      optgroup = "#{dict}: #{paradigm} #{part}"

			# need to set id or otherwise make it optionable
			new_senses[optgroup] = [sense.subentry.senses.build(:definition => "(new sense under this subentry...)"), sense.subentry.id]

      [optgroup, sense.definition, sense.id]
    end
    
    output = {}
    
    groups.each do |group|
      if output.has_key? group.first # if we already have optgroup X, append
        output[group.first] << [group.second, group.last]
      else # otherwise, create optgroup X
        output[group.first] = [[group.second, group.last]]
      end
    end
    
    output.each do |k_group, v_members|
    	v_members << [new_senses[k_group][0].definition, "new-#{new_senses[k_group][1]}"]
    end
    
    output.to_a
  end
  
  # Injects into ApplicationHelper#wh's tooltip the first definition assigned 
  # to each word.
  # Assumes parses are as given in the example, in the same order, but not 
  # necessarily contiguous (can probably tidy if we assume no insertions?)
  def wh_parsed locus, text, highlight=[]
    wh(text, highlight) do |parse, index|
      words = locus.example.scan(/\[\[([^|]+?)\]\]|\[\[(.+?)\|/).flatten.compact
      nth_parse = words[0, index].count(parse) 
      all_matching = locus.parses.find_all {|p| parse == (p.parsed_form) }
      sense = all_matching[nth_parse].try(:interpretations).try(:first).try(:sense)
      sense.try(:definition)
    end
  end
end