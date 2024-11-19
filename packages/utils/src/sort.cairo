/// Bubble sort from
/// https://github.com/keep-starknet-strange/alexandria/blob/main/packages/sorting/src/bubble_sort.cairo
pub fn bubble_sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(mut array: Span<T>) -> Array<T> {
    if array.len() == 0 {
        return array![];
    }
    if array.len() == 1 {
        return array![*array[0]];
    }
    let mut idx1 = 0;
    let mut idx2 = 1;
    let mut sorted_iteration = true;
    let mut sorted_array = array![];

    loop {
        if idx2 == array.len() {
            sorted_array.append(*array[idx1]);
            if sorted_iteration {
                break;
            }
            array = sorted_array.span();
            sorted_array = array![];
            idx1 = 0;
            idx2 = 1;
            sorted_iteration = true;
        } else {
            if *array[idx1] <= *array[idx2] {
                sorted_array.append(*array[idx1]);
                idx1 = idx2;
                idx2 += 1;
            } else {
                sorted_array.append(*array[idx2]);
                idx2 += 1;
                sorted_iteration = false;
            }
        };
    };
    sorted_array
}

pub fn merged_sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(mut array: Span<T>) -> Array<T> {
    let len = array.len();
    if len == 0 {
        return array![];
    }
    if len == 1 {
        return array![*array[0]];
    }

    // Create left and right arrays
    let middle = len / 2;
    let left_arr = array.slice(0, middle);
    let right_arr = array.slice(middle, len - middle);

    // Recursively sort the left and right arrays
    let sorted_left = merged_sort(left_arr);
    let sorted_right = merged_sort(right_arr);

    let mut result_arr = array![];
    merge_recursive(sorted_left, sorted_right, ref result_arr, 0, 0);
    result_arr
}

// Merge two sorted arrays
/// # Arguments
/// * `left_arr` - Left array
/// * `right_arr` - Right array
/// * `result_arr` - Result array
/// * `left_arr_ix` - Left array index
/// * `right_arr_ix` - Right array index
/// # Returns
/// * `Array<usize>` - Sorted array
fn merge_recursive<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(
    mut left_arr: Array<T>,
    mut right_arr: Array<T>,
    ref result_arr: Array<T>,
    left_arr_ix: usize,
    right_arr_ix: usize
) {
    if result_arr.len() == left_arr.len() + right_arr.len() {
        return;
    }

    if left_arr_ix == left_arr.len() {
        result_arr.append(*right_arr[right_arr_ix]);
        return merge_recursive(left_arr, right_arr, ref result_arr, left_arr_ix, right_arr_ix + 1);
    }

    if right_arr_ix == right_arr.len() {
        result_arr.append(*left_arr[left_arr_ix]);
        return merge_recursive(left_arr, right_arr, ref result_arr, left_arr_ix + 1, right_arr_ix);
    }

    if *left_arr[left_arr_ix] < *right_arr[right_arr_ix] {
        result_arr.append(*left_arr[left_arr_ix]);
        merge_recursive(left_arr, right_arr, ref result_arr, left_arr_ix + 1, right_arr_ix)
    } else {
        result_arr.append(*right_arr[right_arr_ix]);
        merge_recursive(left_arr, right_arr, ref result_arr, left_arr_ix, right_arr_ix + 1)
    }
}
