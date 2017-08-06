module dlangide.ui.homescreen;

import dlangui.widgets.layouts;
import dlangui.widgets.widget;
import dlangui.widgets.scroll;
import dlangui.widgets.controls;
import dlangide.ui.frame;
import dlangide.ui.commands;
import dlangui.core.i18n;

import std.path;
import std.utf : toUTF32;

class HomeScreen : ScrollWidget {
    protected IDEFrame _frame;
    protected HorizontalLayout _content;
    protected VerticalLayout _startItems;
    protected VerticalLayout _recentItems;
    this(string ID, IDEFrame frame) {
        super(ID);
        import dlangide.ui.frame;
        //styleId = STYLE_EDIT_BOX;
        _frame = frame;
        uint linkColor = currentTheme.customColor("link_color", 0x2020FF);
        _content = new HorizontalLayout("HOME_SCREEN_BODY");
        _content.layoutWidth(FILL_PARENT).layoutHeight(FILL_PARENT);
        VerticalLayout _column1 = new VerticalLayout();
        int pad = BACKEND_GUI ? 20 : 1;
        _column1.layoutWidth(FILL_PARENT).layoutHeight(FILL_PARENT).padding(Rect(pad, pad, pad, pad));
        VerticalLayout _column2 = new VerticalLayout();
        _column2.layoutWidth(FILL_PARENT).layoutHeight(FILL_PARENT).padding(Rect(pad, pad, pad, pad));
        _content.addChild(_column1);
        _content.addChild(_column2);
        _column1.addChild((new TextWidget(null, "Dlang IDE "d ~ DLANGIDE_VERSION)).fontSize(32).textColor(linkColor));
        _column1.addChild((new TextWidget(null, UIString("DESCRIPTION"c))).fontSize(20));
        _column1.addChild((new TextWidget(null, UIString("COPYRIGHT"c))).fontSize(22).textColor(linkColor));
        _column1.addChild(new VSpacer());
        _column1.addChild((new TextWidget(null, UIString("START_WITH"c))).fontSize(20).textColor(linkColor));
        _startItems = new VerticalLayout();
        _recentItems = new VerticalLayout();
        _startItems.addChild(new ImageTextButton(ACTION_FILE_OPEN_WORKSPACE));
        _startItems.addChild(new ImageTextButton(ACTION_FILE_NEW_WORKSPACE));
        _startItems.addChild(new ImageTextButton(ACTION_FILE_NEW_PROJECT));
        _column1.addChild(_startItems);
        _column1.addChild(new VSpacer());
        
        // Recent workspaces 
        _column1.addChild((new TextWidget(null, UIString("RECENT"c))).fontSize(20).textColor(linkColor));
        string[] recentWorkspaces = _frame.settings.recentWorkspaces;
        if (recentWorkspaces.length) {
            foreach(fn; recentWorkspaces) {
                Action a = ACTION_FILE_OPEN_WORKSPACE.clone();
                a.label = UIString(toUTF32(stripExtension(baseName(fn))));
                a.stringParam = fn;
                _column1.addChild(new LinkButton(a));
            }
        } else {
            _recentItems.addChild((new TextWidget(null, UIString("NO_RECENT"c))));
        }
        _column1.addChild(_recentItems);
        
        // Useful links
        _column1.addChild(new VSpacer());
        _column2.addChild((new TextWidget(null, UIString("USEFUL_LINKS"c))).fontSize(20).textColor(linkColor));
        _column2.addChild(new UrlImageTextButton(null, UIString("D_LANG"c).value, "http://dlang.org/"));
        _column2.addChild(new UrlImageTextButton(null, UIString("DUB_REP"c).value, "http://code.dlang.org/"));
        _column2.addChild(new UrlImageTextButton(null, UIString("DLANG_UI"c).value, "https://github.com/buggins/dlangui"));
        _column2.addChild(new UrlImageTextButton(null, UIString("DLANG_IDE"c).value, "https://github.com/buggins/dlangide"));
        _column2.addChild(new VSpacer());
        contentWidget = _content;
    }
}
