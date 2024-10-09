{ hyprland, writers }:

writers.writePython3Bin "hyprlayout" { } ''
  import argparse
  import json
  import subprocess
  import sys


  hyprctl = (
      '${hyprland}'
      + '/bin/hyprctl'
  )


  layouts = {
      'English (US)': 1,
      'Russian': 0,
  }


  def get_layout(*args, **kwargs):
      result = subprocess.run(
          [f'{hyprctl}', 'devices', '-j'], stdout=subprocess.PIPE
      )
      data = json.loads(result.stdout.decode('utf-8'))
      layout = data['keyboards'][0]['active_keymap']
      sys.stdout.write(f'{layout}\n')


  def get_layout_id(*args, **kwargs):
      result = subprocess.run(
          [f'{hyprctl}', 'devices', '-j'], stdout=subprocess.PIPE
      )
      data = json.loads(result.stdout.decode('utf-8'))
      layout = data['keyboards'][0]['active_keymap']
      sys.stdout.write(str(layouts[layout]))


  def set_layout(id=None, *args, **kwargs):
      result = subprocess.run(
          [f'{hyprctl}', 'devices', '-j'], stdout=subprocess.PIPE
      )
      data = json.loads(result.stdout.decode('utf-8'))
      keyboards = map(lambda dct: dct['name'], data['keyboards'])
      current_layout = data['keyboards'][0]['active_keymap']
      id = id or layouts[current_layout]
      commands = '; '.join(
          map(lambda kbd: f'switchxkblayout {kbd} {id or "next"}', keyboards)
      )
      subprocess.run(
          [f'{hyprctl}', '--batch', commands], stdout=subprocess.DEVNULL
      )


  def get_arg_parser():
      parser = argparse.ArgumentParser()
      parser.add_argument('action', choices=['show', 'show_id', 'next', 'set'])
      parser.add_argument('-i', '--id', type=str)
      return parser


  actions = {
      'show': get_layout,
      'show_id': get_layout_id,
      'set': set_layout,
      'next': set_layout,
  }


  if __name__ == '__main__':
      parser = get_arg_parser()
      args = parser.parse_args()
      actions[args.action](args.id)
''
