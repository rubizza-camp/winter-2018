module URLGenerator
  GENIUS_CLIENT_ACCESS_TOKEN = 'UHVl_2_PjW-s822Fu7gOFmff36wxSp3DzDxBka6RXnVo8-faKawrNSJNjYhwiril'
  GENIUS_API_URL = 'https://api.genius.com'.freeze
  GENIUS_URL = 'https://genius.com'.freeze

  def gen_artist_url(id)
    url = URI(GENIUS_API_URL + '/artists/' + id.to_s + '/songs')
    params = { access_token: GENIUS_CLIENT_ACCESS_TOKEN }
    url.query = URI.encode_www_form(params)
    url
  end

  def gen_song_url(link)
    url = URI(GENIUS_URL + link)
    url
  end
end