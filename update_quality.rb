require 'award'
# Notes on line 71: 
def update_quality(awards)
  awards.each do |award|
    # update blue star plans
    if award.name == 'Blue Star' && award.quality > 0
      award.quality -= 2
    end

    # awards passed: 'normal item', 'Blue Distinction Plus', 'Blue Star'
    if award.name != 'Blue First' && award.name != 'Blue Compare' 
      if award.quality > 0
        if award.name != 'Blue Distinction Plus' && award.name != 'Blue Star'
          # awards pass 'normal item'
          award.quality -= 1
        end
      end
    else
      # adds quality to 'Blue first' + 'blue compare' that are less then 50
      if award.quality < 50 
        award.quality += 1
        # adds to blue compare
        if award.name == 'Blue Compare'
          if award.expires_in < 11
            if award.quality < 50
              award.quality += 1
            end
          end
          if award.expires_in < 6
            if award.quality < 50
              award.quality += 1
            end
          end
        end
      end
    end
    # after huge if else, all awards.qualities are updates + or - 1
    
    # decrease expiration day by one 
    if award.name != 'Blue Distinction Plus'
      award.expires_in -= 1
    end
    
    # this is where you do the logic for degrading based on expired days for normal items and blue star
    if award.expires_in < 0
      if award.name != 'Blue First'
        if award.name != 'Blue Compare'
          if award.quality > 0
            if award.name != 'Blue Distinction Plus' 
              # decrease normal items and blue star
              award.quality -= 1
              if award.name == 'Blue Star'
                # blue star degrade twice as much 
                award.quality -= 1
              end
            end
          end
        else
          # after expiration quality zero'd for blue compare
          award.quality = 0
        end
      else
        # adds to blue first that are expired
        if award.quality < 50
          award.quality += 1
        end
      end
    end
  end
end
###########################################################################
# NOTE: refactored code not on this file, but injected solution into legacy code
# when refactoring the code I noticed:
#  [ ] Award Quality is negative on one rspec test; 
#      however, description states “The quality of an award is never negative.”?
#  [ ] Updates expire_in days, after updating quality point; 
#      if the days of expiration update at the end the day,
#      shouldn’t the expires_in be the first updateand then update values base on the new expires_in integer 
#  [ ] Appears that normal items degrade by 2 on some tests... 
#  [ ] Test description does not reflect specify on some tests
#############################################################################