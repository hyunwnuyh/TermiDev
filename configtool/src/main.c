#include <ncurses.h>
#include <string.h>

void display_mainmenu ();

int main (int argc, char *argv[]) {
    
    WINDOW* win = initscr();
    raw();
    keypad(stdscr, TRUE);
    noecho();
    display_mainmenu();
    endwin();

    return 0;
}

void display_mainmenu ()
{
    char *title = "TermiDev-C Configuration Window";
    border('|', '|', '-', '-', '+', '+', '+', '+');
    mvprintw(2, (COLS - strlen(title)) / 2, title);
    refresh();
    getch();
}
