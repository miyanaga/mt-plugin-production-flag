package MT::ProductionFlag::CMS;

use strict;
use warnings;

sub template_param_edit_entry {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $perms = $app->permissions;
    return 1 unless $perms->can_do('set_production_flag');

    my $node = $tmpl->createElement('app:setting', { id => 'production_flag', label_class => 'top-label' });
    $node->innerHTML(<<'MTML');
<__trans_section component="ProductionFlag">
<label id="production_flag">
    <input type="checkbox" class="cb" name="production_flag" value="1"<mt:if name="production_flag"> checked="checked"</mt:if> />
    <input type="hidden" name="production_flag" value="0" />
    <strong><__trans phrase="Is Production"></strong>
</label>
</__trans_section>
MTML

    my @settings = grep { $_->getAttribute('id') eq 'status' } @{ $tmpl->getElementsByTagName('app:setting') };
    $tmpl->insertAfter($node, $settings[0]);

    1;
}

sub cms_pre_save_entry {
    my ( $cb, $app, $entry, $orig ) = @_;
    my $flag = $app->param('production_flag') || 0;
    $entry->production_flag($flag);

    1;
}

sub list_properties {
    my $component = MT->component('ProductionFlag');
    +{
        entry => {
            production_flag => {
                label => 'Prod.',
                order => 100,
                display => 'default',
                base => '__virtual.single_select',
                col_class => 'col id',
                singleton => 1,
                single_select_options => [
                    {
                        label => $component->translate('Enabled'),
                        value => 1,
                    },
                    {
                        label => $component->translate('Disabled'),
                        value => 0,
                    },
                ],
                bulk_html => sub {
                    my $prop     = shift;
                    my ($objs)   = @_;

                    my $icon = MT->static_path . 'images/status_icons/success.gif';
                    map {
                        $_->production_flag ? qq{<img src="$icon" />} : '',
                    } @$objs;
                },
            },
        },
    }
}

1;
