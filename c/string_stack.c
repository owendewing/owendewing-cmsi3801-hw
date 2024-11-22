#include "string_stack.h"
#include <stdlib.h>
#include <string.h>

#define INITIAL_CAPACITY 16

struct _Stack {
    char **elements;
    int top;
    int capacity;
};

stack_response create() {
    stack_response response;

    stack new_stack = malloc(sizeof(struct _Stack));
    if (new_stack == NULL) {
        response.code = out_of_memory;
        response.stack = NULL;
        return response;
    }

    new_stack->elements = malloc(INITIAL_CAPACITY * sizeof(char *));
    if (new_stack->elements == NULL) {
        free(new_stack);
        response.code = out_of_memory;
        response.stack = NULL;
        return response;
    }

    new_stack->top = 0;
    new_stack->capacity = INITIAL_CAPACITY;

    response.code = success;
    response.stack = new_stack;
    return response;
}

int size(const stack s) {
    return s->top;
}

bool is_empty(const stack s) {
    return size(s) == 0;
}

bool is_full(const stack s) {
    return s->top == MAX_CAPACITY;
}

response_code push(stack s, char *item) {
    if (strlen(item) >= MAX_ELEMENT_BYTE_SIZE) {
        return stack_element_too_large;
    }

    if (is_full(s)) {
        return stack_full;
    }

    char *copied_item = strdup(item);
    if (copied_item == NULL) {
        return out_of_memory;
    }

    if (s->top == s->capacity) {
        int new_capacity = s->capacity * 2;
        if (new_capacity > MAX_CAPACITY) {
            new_capacity = MAX_CAPACITY;
        }
        char **new_elements = realloc(s->elements, new_capacity * sizeof(char *));
        if (new_elements == NULL) {
            free(copied_item);
            return out_of_memory;
        }
        s->elements = new_elements;
        s->capacity = new_capacity;
    }

    s->elements[s->top++] = copied_item;
    return success;
}

string_response pop(stack s) {
    string_response response;
    if (is_empty(s)) {
        response.code = stack_empty;
        response.string = NULL;
        return response;
    }

    response.code = success;
    response.string = s->elements[--s->top];

    if (s->top > 0 && s->top <= s->capacity / 4 && s->capacity > INITIAL_CAPACITY) {
        int new_capacity = s->capacity / 2;
        if (new_capacity < INITIAL_CAPACITY) {
            new_capacity = INITIAL_CAPACITY;
        }

        char **new_elements = realloc(s->elements, new_capacity * sizeof(char *));
        if (new_elements != NULL) {
            s->elements = new_elements;
            s->capacity = new_capacity;
        }
    }

    return response;
}

void destroy(stack *s) {
    if (s == NULL || *s == NULL) {
        return;
    }

    for (int i = 0; i < (*s)->top; i++) {
        free((*s)->elements[i]);
    }

    free((*s)->elements);
    free(*s);
    *s = NULL;
}