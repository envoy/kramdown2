# -*- coding: utf-8; frozen_string_literal: true -*-
#
#--
# Copyright (C) 2009-2019 Thomas Leitner <t_leitner@gmx.at>
#
# This file is part of kramdown2 which is licensed under the MIT.
#++
#

require 'kramdown2/parser/kramdown2/blank_line'
require 'kramdown2/parser/kramdown2/extensions'
require 'kramdown2/parser/kramdown2/eob'

module Kramdown2
  module Parser
    class Kramdown2

      BLOCKQUOTE_START = /^#{OPT_SPACE}> ?/

      # Parse the blockquote at the current location.
      def parse_blockquote
        start_line_number = @src.current_line_number
        result = @src.scan(PARAGRAPH_MATCH)
        until @src.match?(self.class::LAZY_END)
          result << @src.scan(PARAGRAPH_MATCH)
        end
        result.gsub!(BLOCKQUOTE_START, '')

        el = new_block_el(:blockquote, nil, nil, location: start_line_number)
        @tree.children << el
        parse_blocks(el, result)
        true
      end
      define_parser(:blockquote, BLOCKQUOTE_START)

    end
  end
end
