HostProvider.find_or_create_by(name: 'mega') do |m|
  m.url = 'https://mega.nz'
  m.default_storage_limit = 50.gigabytes
end

HostProvider.find_or_create_by(name: 'backblaze') do |m|
  m.url = 'https://www.backblaze.com/b2/cloud-storage.html'
end

# [
#   {
#     name: 'SBS Inkigayo',
#     possible_names: [
#       'SBS인기가요',
#       'SBS 인기가요',
#       '인기가요',
#       'Inkigayo',
#       'Inkygayo'
#     ]
#   },

#   {
#     name: 'MBC Music Core',
#     possible_names: [
#       '쇼 음악중심',
#       '쇼! 음악중심',
#       '쇼!음악중심',
#       '쇼음악중심',
#       '음악중심',
#       'Music Core'
#     ]
#   },

#   {
#     name: 'KBS Music Bank',
#     possible_names: [
#       'KBS 뮤직뱅크',
#       'KBS뮤직뱅크',
#       '뮤직뱅크',
#       'Music Bank'
#     ]
#   },

#   {
#     name: 'Oak Valley Snow White Festival',
#     possible_names: [
#      '한솔 오크밸리',
#     ]
#   },

#   {
#     name: "SBS Kim Jung Eun's Chocolate",
#     possible_names: [
#      '김정은의 초콜릿',
#      'SBS 김정은의 초콜릿',
#      'SBS김정은의 초콜릿'
#     ]
#   },

#   {
#     name: 'Mnet M!Countdown',
#     possible_names: [
#       '엠카운트다운',
#       'Mnet 엠카운트다운',
#       'Mnet엠카운트다운'
#     ]
#   },

#   {
#     name: 'Open Concert',
#     possible_names: [
#      '열린음악회'
#     ]
#   }
# ].each do |event_hash|
#   Event.find_or_create_by(name: event_hash[:name]) do |m|
#     m.possible_name = event_hash[:possible_names]
#   end
# end
