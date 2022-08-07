module Tech_Pronouns
    attr_accessor :they
    attr_accessor :them
    attr_accessor :their
    attr_accessor :theirs
    attr_accessor :themself
    attr_accessor :is
    attr_accessor :conjugation
    attr_accessor :person
   
      @they              = "they"
      @them              = "them"
      @their             = "their"
      @theirs            = "theirs"
      @themself          = "themself"
      @is                = false
      @conjugation       = ""
      @person            = "person"
    
  end
  
  
  class Player
    include Tech_Pronouns
  end
  
  def useIs
    return $Trainer.is
  end
  
  
  def pronounsHim
      $Trainer.they              = "he"
      $Trainer.them              = "him"
      $Trainer.their             = "his"
      $Trainer.theirs            = "his"
      $Trainer.themself          = "himself"
      $Trainer.is                = true
      $Trainer.conjugation       = "o"
  end
  
  def pronounsHer
      $Trainer.they              = "she"
      $Trainer.them              = "her"
      $Trainer.their             = "her"
      $Trainer.theirs            = "hers"
      $Trainer.themself          = "herself"
      $Trainer.is                = true
      $Trainer.conjugation       = "a"
  end
  
  def pronounsThey
      $Trainer.they              = "they"
      $Trainer.them              = "them"
      $Trainer.their             = "their"
      $Trainer.theirs            = "theirs"
      $Trainer.themself          = "themself"
      $Trainer.is                = false
      $Trainer.conjugation       = "o"
  end
  
  
  def pronounsIt
      $Trainer.they              = "it"
      $Trainer.them              = "it"
      $Trainer.their             = "its"
      $Trainer.theirs            = "its"
      $Trainer.themself          = "itself"
      $Trainer.is                = true
      $Trainer.conjugation       = "o"
  end
  
  def pronounsCustom
    pronoun = ""
    pronoun = pbMessageFreeText(_INTL("He/She/They"),"",false,8)
    $Trainer.they     = pronoun
    pronoun = pbMessageFreeText(_INTL("Him/Her/Them"),"",false,8)
    $Trainer.them     = pronoun
    pronoun = pbMessageFreeText(_INTL("His/Her/Their"),"",false,8)
    $Trainer.their    = pronoun
    pronoun = pbMessageFreeText(_INTL("His/Hers/Theirs"),"",false,8)
    $Trainer.theirs   = pronoun
    pronoun = pbMessageFreeText(_INTL("Himself/Herself/Theirself"),"",false,8)
    $Trainer.themself = pronoun
    $Trainer.conjugation = "o"
    #===============================##
    # Spanish translation needs proper adjective (and occasionally noun) endings too
    #===============================##
    if $PokemonSystem.language == 1 # Spanish
      pronoun = pbMessageFreeText(_INTL("¿Qué usa para terminar adjetivos, como el \"o\" en \"alto\"?"),
                                    "",false,2)
      $Trainer.conjugation = pronoun
    end
    #===============================##
    command = 0
    loop do
      command = pbMessage(_INTL("{1} is or {1} are?",$Trainer.they),[
         _INTL("{1} is",$Trainer.they),
         _INTL("{1} are",$Trainer.they)
         ],-1,nil,command)
      case command
      when 0;
        $Trainer.is = true
        break
      when 1;
        $Trainer.is = false
        break
      end
    end
  end
  
  
  def pronounsPerson(base)
    $Trainer.person = base
    command = 0
    loop do
      command = pbMessage(_INTL("I am a..."),[
         _INTL("{1}",base),
         _INTL("person"),
         _INTL("(custom)"),
         ],-1,nil,command)
      case command
      when 0;
        $Trainer.person = base
        break
      when 1;
        $Trainer.person = "person"
        break
      when 2;
        $Trainer.person = pbMessageFreeText(_INTL("I am a..."),"",false,8)
        break
      end
    end
   
  end
  
  
  def pbPronouns
    command = 0
    loop do
      command = pbMessage(_INTL("Update pronouns?"),[
         _INTL("He/Him"),
         _INTL("She/Her"),
         _INTL("They/Them"),
         _INTL("It/Its"),
         _INTL("Custom"),
         _INTL("Exit")
         ],-1,nil,command)
      case command
      when 0;
        pronounsHim
        pronounsPerson("man")
        pbMessage(_INTL("Updated to {1} / {2}.",$Trainer.they,$Trainer.them))
        break
      when 1;
        pronounsHer
        pronounsPerson("woman")
        pbMessage(_INTL("Updated to {1} / {2}.",$Trainer.they,$Trainer.them))
        break
      when 2;
        pronounsThey
        pronounsPerson("trainer")
        pbMessage(_INTL("Updated to {1} / {2}.",$Trainer.they,$Trainer.them))
        break
      when 3;
        pronounsIt
        pronounsPerson("trainer")
        pbMessage(_INTL("Updated to {1} / {2}.",$Trainer.they,$Trainer.them))
        break
      when 4;
        pronounsCustom
        pronounsPerson("trainer")
        pbMessage(_INTL("Updated to {1} / {2}.",$Trainer.they,$Trainer.them))
        break
        else; break
      end
    end
  end
  
  
  def pbTrainerPCMenu
    command = 0
    loop do
      command = pbMessage(_INTL("What do you want to do?"),[
         _INTL("Item Storage"),
         _INTL("Mailbox"),
         _INTL("Pronouns"),
         _INTL("Turn Off")
         ],-1,nil,command)
      case command
      when 0; pbPCItemStorage
      when 1; pbPCMailbox
      when 2; pbPronouns
      else; break
      end
    end
  end
  
     unless Kernel.respond_to?(:pbMessageDisplay_Old)
        alias pbMessageDisplay_Old pbMessageDisplay
        def pbMessageDisplay(*args)
          if $Trainer
            if $Trainer.themself
              if $Trainer.is==true
                args[1].gsub!(/\\hes/i,_INTL("{1}'s",$Trainer.they.downcase))
                args[1].gsub!(/\\uheis/i,_INTL("{1} is",$Trainer.they.capitalize))
                args[1].gsub!(/\\heis/i,_INTL("{1} is",$Trainer.they.downcase))
                args[1].gsub!(/\\uhes/i,_INTL("{1}'s",$Trainer.they.capitalize))
              end
              if $Trainer.is==false
                args[1].gsub!(/\\hes/i,_INTL("{1}'re",$Trainer.they.downcase))
                args[1].gsub!(/\\heis/i,_INTL("{1} are",$Trainer.they.downcase))
                args[1].gsub!(/\\uhes/i,_INTL("{1}'re",$Trainer.they.capitalize))
                args[1].gsub!(/\\uheis/i,_INTL("{1} are",$Trainer.they.capitalize))
              end
            args[1].gsub!(/\\he/i,$Trainer.they.downcase)
            args[1].gsub!(/\\uhe/i,$Trainer.they.capitalize)
            args[1].gsub!(/\\him/i,$Trainer.them.downcase)
            args[1].gsub!(/\\uhim/i,$Trainer.them.capitalize)
            args[1].gsub!(/\\his/i,$Trainer.their.downcase)
            args[1].gsub!(/\\uhis/i,$Trainer.their.capitalize)
            args[1].gsub!(/\\hrs/i,$Trainer.theirs.downcase)
            args[1].gsub!(/\\uhrs/i,$Trainer.theirs.capitalize)
            args[1].gsub!(/\\slf/i,$Trainer.themself.downcase)
            args[1].gsub!(/\\uslf/i,$Trainer.themself.capitalize)
            args[1].gsub!(/\\oa/o,$Trainer.conjugation.downcase)
            args[1].gsub!(/\\man/i,$Trainer.person.downcase)
            args[1].gsub!(/\\uman/i,$Trainer.person.capitalize)
          end
        end
          return pbMessageDisplay_Old(*args)
        end
  end